(ido-mode t)
(menu-bar-mode -1)

(setq-default indent-tabs-mode nil)

(setq ido-enable-flex-matching t
      inhibit-splash-screen t
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))

(set-face-foreground 'vertical-border "white")

(global-set-key (kbd "C-x m") 'eshell)

(global-set-key (kbd "f6") 'jarvis-random)
(global-set-key (kbd "f8") 'jarvis-choose)
(global-set-key (kbd "f8") 'jarvis-toggle)
(global-set-key (kbd "f9") 'jarvis-prev)
(global-set-key (kbd "f10") 'jarvis-next)

(global-set-key (kbd "M-S-f12") (lambda () (interactive)
                                  (shell-command "sudo halt")))

(jarvis-init)
