# ~/.config/fish/config.fish
# Ported from .zshrc, which remains available as a fallback.
# Fish gives you out of the box what zsh needed plugins for:
# syntax highlighting, autosuggestions, man-page completions, and history
# substring search on the arrow keys.

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx EDITOR emacs
set -gx GIT_EDITOR nvim
set -gx EZA_CONFIG_DIR "$XDG_CONFIG_HOME/eza"

# PATH (fish_add_path prepends once, no duplicates)
fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "$HOME/.opencode/bin"
fish_add_path ~/.config/emacs/bin

if test (uname) = Darwin
    # bob (neovim version manager) proxy, prepended so it shadows /usr/local/bin
    fish_add_path -g "$HOME/Library/Application Support/bob/nvim-bin"
    # online-judge-tools (oj) - Codeforces submission from the terminal
    fish_add_path -g "$HOME/Library/Python/3.12/bin"
    # Homebrew GCC provides the GNU C++ headers used by competitive programming
end

# ghcup: the shipped ~/.ghcup/env is POSIX sh and can't be sourced by fish,
# so just add the bins directly.
fish_add_path -g "$HOME/.ghcup/bin" "$HOME/.cabal/bin"

# rustup: same story as ghcup, ~/.cargo/env is POSIX sh, add the bin directly.
fish_add_path -g "$HOME/.cargo/bin"

# Julia, installed through juliaup.
fish_add_path -g "$HOME/.juliaup/bin"

# aliases
alias n='nvim'
alias lg='lazygit'
alias gst='git status'
alias ls='eza'
alias karabiner="/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile"
alias c='clear'
alias q='exit'

if status is-interactive
    # Fish's default key bindings are already emacs-style, and up/down do
    # history substring search natively, so nothing to bind here.

    command -q zoxide; and zoxide init fish | source
    command -q starship; and starship init fish | source
end

# kimi-code
fish_add_path -g "/Users/colmraffertyjr/.kimi-code/bin"
