;;; appearance.el --- Theme, tabs, Dired, and visual helpers -*- lexical-binding: t; -*-

;;; Code:

(add-to-list 'custom-theme-load-path
             (expand-file-name "themes/" my/config-directory))
(mapc #'disable-theme custom-enabled-themes)
(load-theme 'gruvbox-nvim t)

(use-package dired
  :ensure nil
  :custom
  (insert-directory-program "/opt/homebrew/bin/gls")
  (dired-use-ls-dired t))

(use-package tab-bar
  :ensure nil
  :demand t
  :custom
  (tab-bar-show 1)
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

;;; appearance.el ends here
