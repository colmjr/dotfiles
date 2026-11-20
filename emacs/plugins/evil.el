;;; evil.el --- Evil and its editing extensions -*- lexical-binding: t; -*-

;;; Code:

(use-package evil
  :ensure t
  :init
  ;; workaround emacs 31 evil bug
  (defvar evil-mode-buffers nil)
  (setq evil-want-keybinding nil
	evil-want-C-u-scroll t
	evil-want-C-i-jump t
	evil-ex-search-highlight-all t
	evil-ex-search-persistent-highlight t
	evil-ex-search-incremental t
	evil-undo-system 'undo-redo
	evil-ex-hl-update-delay 0.2)
  :config
  (evil-mode 1)
  (evil-select-search-module 'evil-search-module 'evil-search))

(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

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

;;; evil.el ends here
