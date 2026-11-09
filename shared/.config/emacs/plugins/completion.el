;;; completion.el --- Completion, search, and contextual help -*- lexical-binding: t; -*-

;;; Code:

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

(use-package consult
  :ensure t
  :commands (consult-line consult-buffer consult-recent-file
             consult-ripgrep consult-imenu)
  :after evil)

(use-package consult-lsp
  :ensure t
  :commands consult-lsp-symbols)

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.15)
  :init
  (global-corfu-mode 1))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions
	       #'cape-file))

(use-package rg
  :ensure t
  :defer t)

(use-package embark-consult
  :ensure t)

(use-package embark
  :ensure t
  :commands (embark-act embark-dwim embark-bindings)
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package helpful
  :ensure t
  :commands (helpful-callable helpful-variable helpful-key
             helpful-command helpful-at-point helpful-function))

;;; completion.el ends here
