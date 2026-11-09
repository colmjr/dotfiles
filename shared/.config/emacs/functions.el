;;; functions.el --- Personal commands -*- lexical-binding: t; -*-

;;; Code:

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

(defun my/evil-scroll-up-center ()
  "Center scroll up."
  (interactive)
  (call-interactively #'evil-scroll-up)
  (recenter))

(defun my/evil-scroll-down-center ()
  "Center scroll up."
  (interactive)
  (call-interactively #'evil-scroll-down)
  (recenter))

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

;;; functions.el ends here
