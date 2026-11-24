;;; meow.el --- Meow editing configuration -*- lexical-binding: t; -*-

;;; Code:

(defvar my/leader-map (make-sparse-keymap)
  "Personal command map, shared by C-c SPC and Meow's leader fallback.")

(global-set-key (kbd "C-c SPC") my/leader-map)

(defun my/meow-scroll-half-page-up ()
  "Scroll upward by half a window, then center point."
  (interactive)
  (scroll-down-command (max 1 (/ (window-body-height) 2)))
  (recenter))

(defun my/meow-scroll-half-page-down ()
  "Scroll downward by half a window, then center point."
  (interactive)
  (scroll-up-command (max 1 (/ (window-body-height) 2)))
  (recenter))

(defun my/meow-append-after-cursor ()
  "Append after the cursor, or at the end of an active selection."
  (interactive)
  (unless (or (region-active-p) meow--temp-normal (eolp))
    (forward-char 1))
  ;; Handle the offset here without changing Meow's selection display globally.
  (let ((meow-use-cursor-position-hack nil))
    (meow-append)))

(defun my/save-all-buffers ()
  "Save modified file buffers without prompting."
  (interactive)
  (save-some-buffers t))

(defun my/meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  ;; Keep native keypad prefixes, even where they overlap custom leader keys.
  (setq meow-keypad-start-keys '((?c . ?c) (?h . ?h) (?x . ?x)))
  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '("_" . dired-jump)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("s" . meow-delete)
   '("S" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("?" . lsp-ui-doc-glance)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("d" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat))

  (meow-normal-define-key
   '("C-k" . my/meow-scroll-half-page-up)
   '("C-j" . my/meow-scroll-half-page-down)
   '("C-u" . nil)
   '("C-d" . nil)
   '("C-r" . nil)
   '("U" . universal-argument)))

(use-package meow
  :ensure t
  :demand t
  :custom
  (meow-expand-hint-counts
   '((word . 30)
     (line . 30)
     (block . 30)
     (find . 30)
     (till . 30)
     (symbol . 30)))
  :config
  ;; These keys are window/scroll commands, so editing must call commands directly.
  (setq meow--kbd-kill-region #'kill-region
        meow--kbd-kill-line #'kill-line
        meow--kbd-delete-char #'delete-char)
  (setf (alist-get 'leader meow-keymap-alist) my/leader-map)
  (setq meow-keypad-leader-dispatch "C-c SPC")
  ;; Terminal input must reach Ghostel instead of normal-state editing commands.
  (add-to-list 'meow-mode-state-list '(ghostel-mode . insert))
  (my/meow-setup)
  (define-key meow-insert-state-keymap (kbd "C-SPC") #'completion-at-point)
  (setq meow-char-thing-table
		'((?\( . round)
          (?\[ . square)
          (?\{ . curly)
          (?\" . string)
          (?e . symbol)
          (?p . paragraph)
          (?l . line)
          (?d . defun)
          (?b . buffer)))
  (meow-global-mode 1))

;;; meow.el ends here
