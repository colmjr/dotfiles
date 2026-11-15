;;; git.el --- Git tools and diff indicators -*- lexical-binding: t; -*-

;;; Code:

(use-package magit
  :ensure t
  :commands magit-status)

(use-package diff-hl
  :ensure t
  :demand t
  :custom
  (diff-hl-side 'left)
  (diff-hl-show-staged-changes t)
  :hook
  (magit-post-refresh . diff-hl-magit-post-refresh)
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1))

;;; git.el ends here
