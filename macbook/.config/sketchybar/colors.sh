#!/bin/sh
# Bar palette — sourced by sketchybarrc and plugins ($CONFIG_DIR/colors.sh).
# Switch THEME to "kanagawa" to retheme the whole bar, then: sketchybar --reload
THEME="rose-pine"

case "$THEME" in
  kanagawa)
    # Kanagawa Wave — https://github.com/rebelot/kanagawa.nvim
    export BAR_COLOR=0xf01f1f28      # sumi ink 1
    export ITEM_BG=0xff2a2a37        # sumi ink 4
    export BORDER=0xff54546d         # sumi ink 6
    export TEXT=0xffdcd7ba           # fuji white
    export SUBTLE=0xff727169         # fuji gray
    export ACCENT=0xff7e9cd8         # crystal blue — focused space pill
    export ACCENT_TEXT=0xff1f1f28    # icon color on the ACCENT pill
    export APP=0xff98bb6c            # spring green
    export CLOCK=0xff7aa89f          # wave aqua 2
    export BATTERY=0xffe6c384        # carp yellow
    export VOLUME=0xffd27e99         # sakura pink
    export ALERT=0xffe82424          # samurai red
    ;;
  *)
    # Rosé Pine — https://rosepinetheme.com/palette
    export BAR_COLOR=0xf0191724      # base
    export ITEM_BG=0xff26233a        # overlay
    export BORDER=0xff403d52         # highlight med
    export TEXT=0xffe0def4           # text
    export SUBTLE=0xff908caa         # subtle
    export ACCENT=0xffc4a7e7         # iris — focused space pill
    export ACCENT_TEXT=0xff191724    # icon color on the ACCENT pill
    export APP=0xff31748f            # pine
    export CLOCK=0xff9ccfd8          # foam
    export BATTERY=0xfff6c177        # gold
    export VOLUME=0xffebbcba         # rose
    export ALERT=0xffeb6f92          # love
    ;;
esac
