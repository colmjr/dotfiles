;;; lsp.el --- Language server and floating documentation setup -*- lexical-binding: t; -*-

;;; Code:

(use-package posframe
  :ensure t
  :commands (posframe-show posframe-hide))

(defun my/c-disable-lsp-on-type-formatting ()
  "Use Emacs newline handling instead of LSP on-type formatting in C/C++."
  (setq-local lsp-enable-on-type-formatting nil))

(use-package lsp-mode
  ;; deferred is better perf wise
  :commands (lsp lsp-deferred)
  :ensure t
  :init
  (setq
   lsp-keymap-prefix "C-c l"
   lsp-completion-provider :none
   lsp-diagnostics-provider :flycheck
   ;; make sure aphelia handles formatting
   lsp-enable-on-type-formatting nil
   lsp-enable-indentation nil
   lsp-format-buffer-on-save nil
   lsp-before-save-edits nil
   lsp-enable-snippet t
   lsp-signature-function #'lsp-signature-posframe
   lsp-signature-render-documentation nil
   lsp-signature-posframe-params
   (list :poshandler #'posframe-poshandler-point-bottom-left-corner
		 :max-width 80
		 :max-height 8
		 :min-width 20
		 :border-width 1
		 :left-fringe 8
		 :right-fringe 8)
   lsp-enable-symbol-highlighting t
   lsp-rust-analyzer-lens-implementations-enable nil
   lsp-rust-analyzer-cargo-watch-command "clippy"
   lsp-enable-semantic-highlighting t
   lsp-headerline-breadcrumb-enable t
   lsp-modeline-code-actions-enable t
   )
  :hook
  (((c-mode c++-mode c-ts-mode c++-ts-mode)
    . my/c-disable-lsp-on-type-formatting)
   (c-mode . lsp-deferred)
   (c++-mode . lsp-deferred)
   (c-ts-mode . lsp-deferred)
   (c++-ts-mode . lsp-deferred)
   (rustic-mode . lsp-deferred)
   (gleam-ts-mode . lsp-deferred)
   (haskell-mode . lsp-deferred)
   (haskell-literate-mode . lsp-deferred)))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-use-childframe t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-max-width 80)
  (lsp-ui-doc-max-height 20)
  (lsp-ui-doc-border "#665c54")
  (lsp-ui-sideline-enable nil))

(use-package gleam-ts-mode
  :ensure t
  :mode "\\.gleam\\'")

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-langs '(json python toml))
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package devdocs
  :ensure t
  :bind ("C-h D" . devdocs-lookup))

;;; lsp.el ends here
