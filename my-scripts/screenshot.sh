#!/bin/bash
 
entries="Active Screen Area Window"
 
selected=$(printf '%s\n' $entries | wofi --conf=$HOME/.config/wofi/config.grimshot | awk '{print tolower($1)}')
 
case $selected in
  active)
    /usr/bin/grimshot --notify save active;;
  screen)
    /usr/bin/grimshot --notify save screen;;
  area)
    /usr/bin/grimshot --notify save area;;
  window)
    /usr/bin/grimshot --notify save window;;
esac
