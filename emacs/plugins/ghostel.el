;;; ghostel.el --- Terminal and embedded browser -*- lexical-binding: t; -*-

;;; Code:

(defun my/ghostel-send-C-w ()
  "Send C-w to the terminal instead of using the window prefix."
  (interactive)
  (ghostel-send-key "w" "ctrl"))

(use-package ghostel
  :ensure t
  :commands ghostel
  :config
  ;; Use the option's setter to update keymaps in existing terminal buffers too.
  (customize-set-variable
   'ghostel-keymap-exceptions
   (cons "C-w" (remove "C-w" ghostel-keymap-exceptions)))
  (define-key ghostel-mode-map (kbd "C-c C-w") #'my/ghostel-send-C-w))

(use-package xwidget
  :ensure nil
  :commands xwidget-webkit-browse-url)

;;; ghostel.el ends here
