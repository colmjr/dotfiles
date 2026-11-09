;;; editing.el --- Snippets and formatting -*- lexical-binding: t; -*-

;;; Code:

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))

;;; editing.el ends here
