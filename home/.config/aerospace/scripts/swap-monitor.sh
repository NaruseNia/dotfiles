#!/bin/bash

monitors=$(aerospace list-monitors --format "%{monitor-id}")
[ $(echo "$monitors" | wc -l | tr -d " ") -eq 2 ] || exit 0

focused_monitor=$(aerospace list-monitors --focused --format "%{monitor-id}")
other_monitor=$(echo "$monitors" | grep -v "^${focused_monitor}$" | head -1)

# Get visible workspaces (may be empty or 0)
focused_ws=$(aerospace list-workspaces --monitor "$focused_monitor" --visible || true)
other_ws=$(aerospace list-workspaces --monitor "$other_monitor" --visible || true)

# Normalize workspace 0 → empty
[ "$focused_ws" = "0" ] && focused_ws=""
[ "$other_ws" = "0" ] && other_ws=""

# Count windows on each monitor
focused_windows=$(aerospace list-windows --monitor "$focused_monitor" | wc -l | tr -d " ")
other_windows=$(aerospace list-windows --monitor "$other_monitor" | wc -l | tr -d " ")

# CASE 1: both monitors have windows → illusion swap
if [ "$focused_windows" -gt 0 ] && [ "$other_windows" -gt 0 ]; then
  aerospace focus-monitor "$other_monitor"
  aerospace summon-workspace "$focused_ws"

  aerospace focus-monitor "$focused_monitor"
  aerospace summon-workspace "$other_ws"
  exit 0
fi

# CASE 2: focused has windows, other is empty → move focused ws
if [ "$focused_windows" -gt 0 ] && [ "$other_windows" -eq 0 ]; then
  aerospace focus-monitor "$other_monitor"
  aerospace summon-workspace "$focused_ws"
  aerospace focus-monitor "$focused_monitor"
  exit 0
fi

# CASE 3: other has windows, focused is empty → pull theirs
if [ "$focused_windows" -eq 0 ] && [ "$other_windows" -gt 0 ]; then
  aerospace summon-workspace "$other_ws"
  exit 0
fi

# CASE 4: both empty → do nothing
exit 0
