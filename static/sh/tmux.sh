      if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
        if ! tmux has-session -t default 2>/dev/null; then
          tmux new-session -s default
    fi
        tmux attach-session -t default
fi
