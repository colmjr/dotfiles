;;; projectile.el --- Projectile configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1)
  :init
  (setq projectile-session-autosave t))

;;; projectile.el ends here
