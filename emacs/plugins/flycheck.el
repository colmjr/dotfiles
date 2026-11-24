;;; flycheck.el --- Diagnostics and insert-state annotations -*- lexical-binding: t; -*-

;;; Code:

(use-package flycheck
  :ensure t
  :custom
  (flycheck-annotate-current-line-style 'eol)
  (flycheck-annotate-other-lines-style 'eol)
  (flycheck-indication-mode nil)
  ;; on cursor line
  (flycheck-annotate-levels t)
  (flycheck-annotate-current-line-levels t)
  ;; on other lines
  (flycheck-annotate-other-lines-levels '(error))
  :config
  (global-flycheck-mode 1)
  (global-flycheck-annotate-mode 1)
  (add-hook 'meow-insert-enter-hook
	    (lambda ()
	      (when (bound-and-true-p flycheck-mode)
		(flycheck-annotate-mode -1))))
  (add-hook 'meow-insert-exit-hook
	    (lambda ()
	      (when (bound-and-true-p flycheck-mode)
		(flycheck-annotate-mode 1)))))

;;; flycheck.el ends here
