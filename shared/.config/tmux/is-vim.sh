#!/bin/sh
# vim-tmux-navigator helper: exit 0 if any process in the pane's process
# tree is vim-like. The stock check (ps -t '#{pane_tty}') can't see nvim
# because iris runs programs on its own pty, so walk descendants of the
# pane's root process instead. Usage: is-vim.sh <pane_pid>

is_vim_name() {
  case "${1##*/}" in
    vim | nvim | gvim | gview | view | vimdiff | nvim-*) return 0 ;;
  esac
  return 1
}

walk() {
  is_vim_name "$1" && exit 0
  for child in $(pgrep -P "$2" 2>/dev/null); do
    walk "$(ps -o comm= -p "$child")" "$child"
  done
}

[ -n "$1" ] || exit 1
walk "$(ps -o comm= -p "$1")" "$1"
exit 1
