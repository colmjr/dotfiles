;;; languages.el --- Language modes and LSP clients -*- lexical-binding: t; -*-

;;; Code:

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")

(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'")

(use-package lsp-haskell
  :ensure t)

(use-package lsp-pyright
  :ensure t
  :custom
  (lsp-pyright-langserver-command "basedpyright")
  :hook
  ((python-mode python-ts-mode)
   . (lambda ()
       (require 'lsp-pyright)
       (lsp-deferred))))

;;; languages.el ends here
