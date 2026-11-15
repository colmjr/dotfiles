;;; dashboard.el --- Recent files and startup dashboard -*- lexical-binding: t; -*-

;;; Code:

(use-package recentf
  :ensure nil
  :custom
  (recentf-max-saved-items 200)
  :config
  (recentf-mode 1))

(use-package dashboard
  :ensure t
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-projects-backend 'projectile)
  (dashboard-items
   '((recents . 8)
     (projects . 5)
     (agenda . 5)))
  :config
  (dashboard-setup-startup-hook))

;;; dashboard.el ends here
