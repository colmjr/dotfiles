;;; init.el --- Personal configuration -*- lexical-binding: t; -*-

;;; Code:

(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     t)

(package-initialize)

(require 'use-package)

;; stow problems
(defconst my/config-directory
  (file-name-directory (file-truename (or load-file-name user-init-file)))
  "This is the Emacs config folder.")

;; customize generated form
(setq custom-file (expand-file-name "custom.el" my/config-directory))
(load custom-file 'noerror 'nomessage)

;; use load for my/reload-config
(dolist (file '("functions.el" "plugins.el" "set.el" "keymaps.el"))
  (load (expand-file-name file my/config-directory) nil 'nomessage))
;;; init.el ends here
