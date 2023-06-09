#!/bin/bash

WORK="work"
SSH="ssh"
NOTES="notes"
CONF="conf"
OTHER="other"

tmux start-server

tmux new-session -d -s $WORK
tmux new-session -d -s $SSH
tmux new-session -d -s $NOTES
tmux new-session -d -s $CONF
tmux new-session -d -s $OTHER

# Here you can set up windows or panes for each of your sessions.
# For example, for WORK:

tmux new-window -t $NOTES:1 -n 'notes'
tmux send-keys -t $NOTES:1 'nvim -c ":Neorg index"' C-m

tmux new-window -t $NOTES:2 -n 'journal'
tmux send-keys -t $NOTES:2 'nvim -c ":Neorg journal"' C-m

tmux new-window -t $WORK:1 -n 'api'
tmux send-keys -t $WORK:1 'pApi && nvim' C-m

tmux new-window -t $WORK:2 -n 'ui'
tmux send-keys -t $WORK:2 'pUi && nvim' C-m

tmux new-window -t $CONF:1 -n 'nvim'
tmux send-keys -t $CONF:1 'pConf && cd astro-config && nvim .' C-m

tmux new-window -t $CONF:2 -n 'wm'
tmux send-keys -t $CONF:2 'pConf && cd wm-config && nvim .' C-m

tmux new-window -t $CONF:3 -n 'term'
tmux send-keys -t $CONF:3 'pConf && cd term-config && nvim .' C-m


tmux new-window -t $CONF:4 -n 'netplan'
tmux send-keys -t $CONF:4 'pConf && cd netplan-config && nvim .' C-m


# ...and so on for the other session(s).
