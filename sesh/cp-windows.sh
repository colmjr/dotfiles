#!/bin/sh
# Window layout for the "cp" sesh session. sesh v2's native `windows` config
# runs `tmux new-window` without -t, so the windows land in whatever session
# launched the picker — target the cp session explicitly instead.
w=$(tmux new-window -d -P -F '#{pane_id}' -t 'cp:' -n cses -c "$HOME/dev/Algos/cses")
tmux send-keys -t "$w" nvim Enter
w=$(tmux new-window -d -P -F '#{pane_id}' -t 'cp:' -n algos -c "$HOME/dev/Algos")
tmux send-keys -t "$w" nvim Enter
exec nvim
