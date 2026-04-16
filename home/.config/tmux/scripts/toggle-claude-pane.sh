#!/bin/bash
cur="$1"
cur_pid=$(tmux display -t "$cur" -p '#{pane_pid}')
if ps -eo ppid,comm | awk -v p="$cur_pid" '$1 == p && $2 == "claude"' | grep -q .; then
  tmux last-window 2>/dev/null || tmux last-pane 2>/dev/null
  exit 0
fi
target=""
while read -r id pid; do
  [ "$id" = "$cur" ] && continue
  if ps -eo ppid,comm | awk -v p="$pid" '$1 == p && $2 == "claude"' | grep -q .; then
    target="$id"; break
  fi
done < <(tmux list-panes -a -F '#{pane_id} #{pane_pid}')
if [ -n "$target" ]; then
  cur_session=$(tmux display -p '#{session_name}')
  target_session=$(tmux display -t "$target" -p '#{session_name}')
  [ "$cur_session" != "$target_session" ] && tmux switch-client -t "$target_session"
  tmux select-window -t "$target"
  tmux select-pane -t "$target"
else
  tmux display "No Claude pane found"
fi
