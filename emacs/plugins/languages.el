;;; languages.el --- Language modes and LSP clients -*- lexical-binding: t; -*-

;;; Code:

(defun my/c-indent-setup ()
  "Use four-space C/C++ indentation matching clang-format."
  (setq-local indent-tabs-mode nil
              tab-width 4)
  (when (bound-and-true-p c-buffer-is-cc-mode)
    (c-set-style "k&r")
    (setq-local c-basic-offset 4)))

(use-package cc-mode
  :ensure nil
  :defer t
  :hook
  ((c-mode c++-mode) . my/c-indent-setup))

(use-package c-ts-mode
  :ensure nil
  :defer t
  :custom
  (c-ts-mode-indent-style 'k&r)
  (c-ts-mode-indent-offset 4)
  :hook
  ((c-ts-mode c++-ts-mode) . my/c-indent-setup))

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
