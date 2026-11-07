;;; Code:
(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	       t)
(package-initialize)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cape consult corfu evil-collection evil-commentary evil-surround
	  flycheck gruvbox-theme haskell-mode leuven-theme lsp-haskell
	  lsp-pyright magit marginalia orderless projectile rg
	  rust-mode vertico yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (load-theme 'leuven-dark t)
(use-package gruvbox-theme
     :ensure t
     :config
     (load-theme 'gruvbox-dark-medium t))

(use-package dired
  :ensure nil
  :custom
  (insert-directory-program "/opt/homebrew/bin/gls")
  (dired-use-ls-dired t))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump t
        evil-ex-search-highlight-all t
        evil-ex-search-persistent-highlight t
        evil-ex-search-incremental t
	evil-undo-system 'undo-redo
        evil-ex-hl-update-delay 0.2
        scroll-margin 7
        scroll-conservatively 101)
  :config
  (evil-mode 1)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-select-search-module 'evil-search-module 'evil-search))

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1)
  :bind
  ("s-p" . projectile-command-map)
  :init
  (setq projectile-session-autosave t))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :ensure t
  :after evil
  :init
  (evil-commentary-mode))

(use-package evil-surround
  :ensure t
  :after (evil evil-collection)
  :config
  (global-evil-surround-mode 1))

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
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer))
  :after evil
  :config
  (evil-define-key 'normal 'global
    (kbd "<leader>sg") #'consult-ripgrep
    (kbd "<leader>ss") #'consult-imenu)
 )

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions
               #'cape-file))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package lsp-mode
  ;; deferred is better perf wise
  :commands (lsp lsp-deferred)
  :ensure t
  :init
  (setq
   lsp-keymap-prefix "C-c l"
   lsp-completion-provider :none
   lsp-diagnostics-provider :flycheck
   lsp-enable-snippet t
   lsp-enable-symbol-highlighting t
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

(use-package rg
  :ensure t
  :defer t)

;; custom functions
(defun my/evil-scroll-up-center ()
  (interactive)
  (call-interactively #'evil-scroll-up)
  (recenter))

(defun my/evil-scroll-down-center ()
  (interactive)
  (call-interactively #'evil-scroll-down)
  (recenter))

;; Keybinds
(define-key evil-normal-state-map (kbd "-") #'dired-jump)
(define-key evil-normal-state-map (kbd "D") (kbd "dd"))
(define-key evil-normal-state-map (kbd "Y") (kbd "yy"))
(define-key evil-normal-state-map (kbd "C-u") #'my/evil-scroll-up-center)
(define-key evil-normal-state-map (kbd "C-d") #'my/evil-scroll-down-center)
(define-key evil-normal-state-map (kbd "K") #'lsp-describe-thing-at-point)
;; TODO: make a keybind to reload config
(set-face-attribute 'default nil :height 210 :family "JetBrains Mono")
(electric-pair-mode 1)
(use-package which-key
  :ensure nil
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.5)
  (which-key-side-window-location 'bottom))
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
