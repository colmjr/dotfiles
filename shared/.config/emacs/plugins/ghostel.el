;;; ghostel.el --- Terminal and embedded browser -*- lexical-binding: t; -*-

;;; Code:

(use-package ghostel
  :ensure t
  :commands ghostel)

(use-package evil-ghostel
  :ensure t
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

(use-package xwidget
  :ensure nil
  :commands xwidget-webkit-browse-url)

;;; ghostel.el ends here
