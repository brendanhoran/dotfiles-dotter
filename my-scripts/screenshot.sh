#!/bin/bash
 
entries="Active Screen Area Window"
 
selected=$(printf '%s\n' $entries | wofi --conf=$HOME/.config/wofi/config.grimshot | awk '{print tolower($1)}')
 
case $selected in
  active)
    grimshot --notify save active;;
  screen)
    grimshot --notify save screen;;
  area)
    grimshot --notify save area;;
  window)
    grimshot --notify save window;;
esac
