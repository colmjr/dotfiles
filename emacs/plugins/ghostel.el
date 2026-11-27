;;; ghostel.el --- Terminal and embedded browser -*- lexical-binding: t; -*-

;;; Code:

(use-package ghostel
  :ensure t
  :commands ghostel
  :config
  ;; Let C-w reach the terminal, restoring its normal terminal behavior.
  (customize-set-variable
   'ghostel-keymap-exceptions
   (remove "C-w" ghostel-keymap-exceptions)))

(use-package xwidget
  :ensure nil
  :commands xwidget-webkit-browse-url)

;;; ghostel.el ends here
