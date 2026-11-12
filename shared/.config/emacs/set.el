;;; set.el --- General Emacs settings -*- lexical-binding: t; -*-

;;; Code:

(setq ring-bell-function #'ignore)
(defalias 'pi 'pilish)

(setq-default indent-tabs-mode t
              tab-width 4)

;; Rust's tree-sitter mode otherwise forces space indentation.
(defun my/use-tabs ()
  "Use tab characters for indentation in the current buffer."
  (setq-local indent-tabs-mode t
              tab-width 4))

(add-hook 'rust-mode-hook #'my/use-tabs)
(add-hook 'rust-ts-mode-hook #'my/use-tabs)

(savehist-mode 1)

(save-place-mode 1)

(global-auto-revert-mode 1)

;; Smooth trackpad scrolling.
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(setq scroll-margin 7
      scroll-conservatively 101)

;;; Fonts and mode line

;; Apply font overrides after package initialization so they stay in effect.
(set-face-attribute 'default nil :height 210 :family "JetBrains Mono")

(set-face-attribute 'fixed-pitch nil :family "JetBrains Mono" :height 1.0)

(electric-pair-mode 1)

(setq display-line-numbers-type 'relative)

(setq mode-line-percent-position nil)

(line-number-mode -1)

(column-number-mode -1)

(blink-cursor-mode -1)

(global-visual-line-mode 1)

(scroll-bar-mode -1)

(display-battery-mode -1)

(tool-bar-mode -1)

;; Keep line numbers in programming buffers only, including after a reload.
(global-display-line-numbers-mode -1)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(dolist (buffer (buffer-list))
  (with-current-buffer buffer
    (when (derived-mode-p 'prog-mode)
      (display-line-numbers-mode 1))))

;;; set.el ends here
