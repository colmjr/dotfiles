;;; plugins.el --- Load package configurations -*- lexical-binding: t; -*-

;;; Code:

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
				"ai.el"
                "ghostel.el"
                "dashboard.el"))
  (load (expand-file-name file
                          (expand-file-name "plugins/" my/config-directory))
        nil 'nomessage))

;;; plugins.el ends here
