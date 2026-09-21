HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks

export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.local/bin:$PATH"

# Rust (rustup)
. "$HOME/.cargo/env"

export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"

# Completion system (fish's man-page completions, zsh edition). Must run before
# zoxide init so it can register completions for z/cd.
if [[ "$OSTYPE" == darwin* ]]; then
  fpath=(/opt/homebrew/share/zsh-completions /opt/homebrew/share/zsh/site-functions $fpath)
fi
autoload -Uz compinit
# Rebuild the completion dump at most once every 24h; otherwise reuse the cache
# (skips the compaudit security scan, which was costing ~200ms per startup).
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select                     # arrow-key menu on tab-tab
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
export GIT_EDITOR="nvim"
export EDITOR="nvim"

if [[ "$OSTYPE" == darwin* ]]; then
  # online-judge-tools (oj) - Codeforces submission from the terminal
  export PATH="$HOME/Library/Python/3.12/bin:$PATH"
  # Homebrew GCC provides the GNU C++ headers used by competitive programming.
  alias g++='/opt/homebrew/bin/g++-15'
fi

alias n='nvim'
alias lg='lazygit'
alias gst='git status'
alias ls='eza'
alias karabiner="/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile"
alias c='clear'
alias q='exit'

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env

# zsh-syntax-highlighting and zsh-history-substring-search: homebrew on macOS,
# /usr/share on Arch (pacman -S zsh-syntax-highlighting zsh-history-substring-search)
if [[ "$OSTYPE" == darwin* ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
else
  [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  [ -f /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh ] && \
    source /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# Use Emacs-style line editing even though EDITOR is set to nvim.
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# tmux names tabs natively via automatic-rename (see tmux.conf) now that no
# pty wrapper hides the running command from it.

command -v starship >/dev/null && eval "$(starship init zsh)"
