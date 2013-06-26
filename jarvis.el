;;; jarvis.el --- An automotive assistant

;; Copyright © 2013 Phil Hagelberg
;;
;; Author: Phil Hagelberg <technomancy@gmail.com>
;; URL: https://github.com/technomancy/jarvis
;; Version: 0.0.1
;; Keywords: automobile

;; This file is not part of GNU Emacs.

;;; Commentary:

;; A UI for initiating a few commands for a computer onboard a car.

;; * Binary clock
;; * Music
;; * Navigation

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'cl)
(require 'dbus)

(load-file "/usr/share/emacs/site-lisp/festival.el")

(defvar jarvis-root (expand-file-name (concat (or load-file-name
                                                  (buffer-file-name)) "/..")))

(defun jarvis-init ()
  (interactive)
  (jarvis-init-clock)
  (jarvis-init-music)
  (festival-say-string "Welcome aboard, sir."))

;;; Clock

(defvar jarvis-hour-pins '(0 1 4 7 8)) ; I guess?

(defvar jarvis-minute-pins '(9 10 11 14 15 17))

(defun jarvis-gpio (pin state)
  (when (file-exists-p "/sys/class/gpio")
    (shell-command (format "echo %s > /sys/class/gpio/gpio%s/value"
                           (if state 1 0) pin))))

(defun jarvis-bits (n)
  (cond ((= 1 n) '(t))
        ((= 0 n) '(nil))
        (t (cons (car (jarvis-bits (mod n 2)))
                 (jarvis-bits (lsh n -1))))))

(defun jarvis-clock ()
  (interactive)
  (let* ((hour (caddr (decode-time (current-time))))
         (minute (cadr (decode-time (current-time))))
         (hour-bits (reverse (jarvis-bits hour)))
         (minute-bits (reverse (jarvis-bits minute))))
    (dotimes (n 5)
      (jarvis-gpio (nth n jarvis-hour-pins) (nth n hour-bits)))
    (dotimes (n 6)
      (jarvis-gpio (nth n jarvis-minute-pins) (nth n minute-bits)))))

(defun jarvis-init-clock ()
  (dolist (p (append jarvis-hour-pins jarvis-minute-pins))
    (shell-command "sudo bash -c \"echo %s > /sys/class/gpio/export\"")
    (shell-command (concat "sudo bash -c \"echo out > /sys/class/gpio/gpio"
                           (number-to-string p) "%s/direction\"")))
  (run-with-timer 0 60 'jarvis-clock))

;;; Music

(defvar jarvis-music-root (expand-file-name "~/music/"))

(defvar jarvis-music-dirs
  (let* ((cmd (format "find %s -type d" jarvis-music-root))
         (dirs (butlast (split-string (shell-command-to-string cmd) "\n"))))
    (mapcar (lambda (d) (substring d (length jarvis-music-root)))
            (cdr dirs))))

(defun jarvis-toggle () (interactive) (shell-command "mpc toggle"))
(defun jarvis-next () (interactive) (shell-command "mpc next"))
(defun jarvis-prev () (interactive) (shell-command "mpc prev"))

(defun jarvis-play (choice)
  (shell-command "mpc clear")
  (shell-command (format "mpc add %s" choice))
  (shell-command "mpc play"))

(defun jarvis-choose ()
  (interactive)
  (jarvis-play (ido-completing-read "Play: " jarvis-music-dirs)))

(defun jarvis-random ()
  (interactive)
  (jarvis-play (nth (random (length jarvis-music-dirs)) jarvis-music-dirs)))

(defun jarvis-init-music ()
  (shell-command "mpc update"))

;;; Navigation

(defun jarvis-init-nav ()
  (unless (dbus-ping :session "org.navit_project.navit")
    (shell-command (format "cd %s; navit -c navit.xml &" jarvis-root))
    (dbus-init-bus :session)))

(defun jarvis-nav-method (method &rest args)
  (jarvis-init-nav)
  (apply 'dbus-call-method :session "org.navit_project.navit"
         "/org/navit_project/navit/default_navit"
         "org.navit_project.navit.navit"
         (symbol-name method) args))

(defun jarvis-nav ()
  (interactive)
  (jarvis-init-nav)
  (jarvis-nav-method 'set_destination
                     (read-from-minibuffer "Destination: ")
                     "destination"))

(defun jarvis-nav-clear ()
  (interactive)
  (jarvis-nav-method 'clear_destination))

(provide 'jarvis) ;;; jarvis.el ends here
