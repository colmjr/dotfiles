;;; lsp.el --- Language server and floating documentation setup -*- lexical-binding: t; -*-

;;; Code:

(use-package posframe
  :ensure t
  :commands (posframe-show posframe-hide))

(use-package lsp-mode
  ;; deferred is better perf wise
  :commands (lsp lsp-deferred)
  :ensure t
  :init
  (setq
   lsp-keymap-prefix "C-c l"
   ;; Corfu uses the LSP CAPF directly; skip Company autoconfiguration.
   lsp-completion-provider :none
   lsp-diagnostics-provider :flycheck
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
   lsp-enable-semantic-highlighting t
   lsp-headerline-breadcrumb-enable t
   lsp-modeline-code-actions-enable t
   )
  :hook
  ((c-mode . lsp-deferred)
   (c++-mode . lsp-deferred)
   (c-ts-mode . lsp-deferred)
   (c++-ts-mode . lsp-deferred)
   (rust-mode . lsp-deferred)
   (rust-ts-mode . lsp-deferred)
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

;;; lsp.el ends here
