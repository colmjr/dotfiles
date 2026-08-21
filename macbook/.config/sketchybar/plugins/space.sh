#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

# icon.highlight swaps the icon to icon.highlight_color so the number stays
# readable on the accent-colored pill
sketchybar --set "$NAME" background.drawing="$SELECTED" icon.highlight="$SELECTED"
