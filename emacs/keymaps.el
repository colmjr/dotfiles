;;; keymaps.el --- Global, Meow, and package-local keybindings -*- lexical-binding: t; -*-

;;; Code:

(defvar-keymap my/window-map
  :doc "Window commands for SPC w and C-c SPC w."
  "h" #'windmove-left
  "j" #'windmove-down
  "k" #'windmove-up
  "l" #'windmove-right
  "v" #'my/vsplit-focus
  "s" #'my/hsplit-focus
  "w" #'other-window
  "C-w" #'other-window
  "W" (lambda () (interactive) (other-window -1))
  "c" #'delete-window
  "q" #'delete-window
  "o" #'delete-other-windows
  "=" #'balance-windows
  "+" #'enlarge-window
  "-" #'shrink-window
  ">" #'enlarge-window-horizontally
  "<" #'shrink-window-horizontally)

(global-set-key (kbd "C-w") #'kill-region)
(global-set-key (kbd "C-x g") #'magit-status)
(global-set-key (kbd "C-s") #'consult-line)
(global-set-key (kbd "C-x b") #'consult-buffer)
(global-set-key (kbd "s-t") #'tab-new)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c t") #'ghostel-project)
(global-set-key (kbd "C-c b") #'xwidget-webkit-browse-url)
(global-set-key (kbd "C-.") #'embark-act)
(global-set-key (kbd "C-;") #'embark-dwim)
(global-set-key (kbd "C-h B") #'embark-bindings)
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h x") #'helpful-command)
(global-set-key (kbd "C-c C-d") #'helpful-at-point)
(global-set-key (kbd "C-h F") #'helpful-function)

(with-eval-after-load 'corfu
  ;; Let Enter use the buffer's normal newline and indentation command.
  (define-key corfu-map (kbd "RET") nil)
  (define-key corfu-map (kbd "<return>") nil)
  (define-key corfu-map (kbd "C-y") #'corfu-insert)
  (define-key corfu-map (kbd "C-e") #'corfu-quit))

(with-eval-after-load 'meow
  ;; On reload this callback can run before Meow's use-package :config.
  (setf (alist-get 'leader meow-keymap-alist) my/leader-map)
  ;; Let C-w use native global and mode-specific bindings.
  (meow-normal-define-key '("C-w" . nil))
  (meow-motion-define-key '("C-w" . nil))
  (meow-define-keys 'insert '("C-w" . nil))
  (define-key my/leader-map (kbd "w") my/window-map)
  (meow-leader-define-key
   '("p" . projectile-command-map)
   '("s g" . consult-ripgrep)
   '("s f" . projectile-find-file)
   '("s t" . projectile-todos)
   '("s s" . consult-lsp-symbols)
   '("s S" . consult-imenu)
   '("s r" . consult-recent-file)
   '("q" . my/flycheck-quickfix-focus)
   '("l a" . lsp-execute-code-action)
   '("l c" . projectile-compile-project)
   '("l d" . lsp-find-definition)
   '("l D" . lsp-find-declaration)
   '("l h" . lsp-ui-doc-glance)
   '("l r" . lsp-find-references)
   '("l R" . projectile-run-project)
   '("l n" . lsp-rename)
   '("l t" . lsp-find-type-definition)
   '("l T" . projectile-test-project)
   '("l i" . lsp-find-implementation)
   '("b k" . kill-current-buffer)
   '("b l" . ibuffer)
   '("b b" . consult-buffer)
   '("b n" . next-buffer)
   '("b p" . previous-buffer)
   '("b s" . my/save-all-buffers)
   '("b x" . scratch-buffer)
   '("b z" . bury-buffer)
   '("TAB" . mode-line-other-buffer)
   '("g n" . diff-hl-next-hunk)
   '("g p" . diff-hl-previous-hunk))

  (with-eval-after-load 'lsp-mode
    (meow-leader-define-key (cons "l l" lsp-command-map)))

  (with-eval-after-load 'rustic
    (meow-leader-define-key
     '("l ." . rustic-cargo-current-test)
     '("l k" . rustic-cargo-check)
     '("l C" . rustic-cargo-clippy)
     '("l p" . rustic-popup)))

  (with-eval-after-load 'lsp-ui
    (define-key lsp-ui-doc-frame-mode-map (kbd "q") #'lsp-ui-doc-hide)
    (define-key lsp-ui-doc-frame-mode-map (kbd "<escape>") #'lsp-ui-doc-hide)))

;;; keymaps.el ends here
