;;; editing.el --- Snippets and formatting -*- lexical-binding: t; -*-

;;; Code:

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode 1))

(use-package surround
  :ensure t
  :bind-keymap ("M-'" . surround-keymap))

;;; editing.el ends here
