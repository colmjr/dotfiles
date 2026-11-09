;;; plugins.el --- Load package configurations -*- lexical-binding: t; -*-

;;; Code:

;; Load by absolute path: plugin filenames must not shadow package libraries.
;; The explicit order keeps foundational packages ahead of their integrations.
(dolist (file '("appearance.el"
                "evil.el"
                "completion.el"
                "projectile.el"
                "git.el"
                "flycheck.el"
                "editing.el"
                "lsp.el"
                "languages.el"
                "org.el"
                "ghostel.el"
                "dashboard.el"))
  (load (expand-file-name file
                          (expand-file-name "plugins/" my/config-directory))
        nil 'nomessage))

;;; plugins.el ends here
