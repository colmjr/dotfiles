;;; functions.el --- Personal commands -*- lexical-binding: t; -*-

;;; Code:
(require 'cl-lib)

(defun my/projectile-compile (&optional arg)
  "Compile the current project without prompting.
   With prefix ARG, prompt for the command."
  (interactive "P")
  (let ((compilation-read-command nil))
    (projectile-compile-project arg)))

(defun my/projectile-run (&optional arg)
  "Run the current project without prompting.
   With prefix ARG, prompt for the command."
  (interactive "P")
  (let ((compilation-read-command nil))
    (projectile-run-project arg)))

(defun my/projectile-test (&optional arg)
  "Test the current project without prompting.
   With prefix ARG, prompt for the command."
  (interactive "P")
  (let ((compilation-read-command nil))
    (projectile-test-project arg)))

(defun my/confirm-func (question fn &rest args)
  "Confirm before calling a function."
  (when (yes-or-no-p question)
	(apply fn args)))

(defun my/projectile-session-restore (&optional arg)
  "Ask to restore projectile session."
  (interactive)
  (my/confirm-func
   "Would you like to restore the last projectile session?"
   #'projectile-session-restore))

(defun my/flycheck-quickfix-focus ()
  "Open quickfix and switch focus."
  (interactive)
  (flycheck-list-errors)
  (when-let ((window (get-buffer-window flycheck-error-list-buffer)))
	(select-window window)))

(defun my/vsplit-focus ()
  "Focus on vertical split window."
  (interactive)
  (select-window (split-window-right)))

(defun my/hsplit-focus ()
  "Focus on horizontal split window."
  (interactive)
  (select-window (split-window-below)))

(defun my/reload-config ()
  "Reload Emacs with init.el."
  (interactive)
  (load-file user-init-file))

;; TODO
(defun my/doom-workspace ()
  "Print workspace tab info."
  (interactive)
  (let ((tabs (cl-loop for tab in (tab-bar-tabs)
					   for i from 1
					   collect (format "[%d]: %s" i (alist-get 'name tab)))))))
;;; functions.el ends here
