;;; languages.el --- Language modes and LSP clients -*- lexical-binding: t; -*-

;;; Code:

(use-package rust-mode
  :ensure t
  :defer t
  :init
  (setq rust-load-optional-libraries nil
        rust-mode-treesitter-derive
        (and (fboundp 'treesit-ready-p)
             (treesit-ready-p 'rust t))))

(use-package rustic
  :ensure t
  :mode ("\\.rs\\'" . rustic-mode)
  :init
  (setq rustic-lsp-setup-p nil
        rustic-format-trigger nil
        rustic-format-on-save nil)
  :custom
  (rustic-cargo-use-last-stored-arguments t))

(defun my/haskell-disable-code-lenses ()
  "Disable automatic LSP code lenses in the current Haskell buffer."
  (setq-local lsp-lens-enable nil))

(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :hook
  ((haskell-mode haskell-literate-mode) . my/haskell-disable-code-lenses))

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
