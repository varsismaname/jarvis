(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(unless (package-installed-p 'better-defaults)
  (package-install 'better-defaults))

(setq ido-mode nil
      inhibit-splash-screen t)

(set-face-foreground 'vertical-border "white")

(load-file "/home/pi/jarvis.el")

(global-set-key (kbd ""))

(jarvis-init)
