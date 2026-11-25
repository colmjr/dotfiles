;;; appearance.el --- Theme, tabs, Dired, and visual helpers -*- lexical-binding: t; -*-

;;; Code:

(load-theme 'gruvbox-dark-hard t)

(use-package dired
  :ensure nil
  :custom
  (insert-directory-program "/opt/homebrew/bin/gls")
  (dired-use-ls-dired t))

(use-package tab-bar
  :ensure nil
  :demand t
  :custom
  (tab-bar-show nil)
  (tab-bar-select-tab-modifiers '(super))
  (tab-bar-tab-hints t)
  :config
  (tab-bar-mode 1)
  (tab-bar-history-mode 1))

(use-package which-key
  :ensure nil
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.5)
  (which-key-side-window-location 'bottom))

(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures
   'prog-mode
   '("==" "!=" "<=" ">="
     "->" "=>" "<-" "<->"
     "::" ":="
     "&&" "||"
     "<<" ">>" ">>=" "=<<"
     "<$>" "<*>" "<|>"
     "++" "--"
     ".." "..." "..="))
  (global-ligature-mode 1))

(use-package nerd-icons
  :ensure t)

(setq mode-line-collapse-minor-modes t
      mode-line-collapse-minor-modes-to "")

;; (use-package keycast
;;   :ensure t
;;   :init
;;   (keycast-header-line-mode 1))

;;; appearance.el ends here
