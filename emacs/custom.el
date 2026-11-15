;;; custom.el --- Settings saved by Customize -*- lexical-binding: t; -*-

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("53b9dd9615039a563a211a7b2437a0af67a0a4bca7323ae6d18ec87606bb8be0"
	 default))
 '(package-selected-packages
   '(agent-shell apheleia ayu-theme cape clippy consult consult-lsp corfu
				 dashboard doom-modeline evil-collection
				 evil-commentary evil-surround flycheck gruvbox-theme
				 haskell-mode helpful leuven-theme lsp-haskell
				 lsp-pyright magit marginalia nerd-icons olivetti
				 orderless pilish projectile rg rust-mode treesit-auto
				 vertico yasnippet)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))

;;; custom.el ends here
