#!/bin/bash

WORK="work"
REST="rest"
SSH="ssh"
NOTES="notes"
CONF="conf"
OTHER="other"

tmux start-server

tmux new-session -d -s $WORK
tmux new-session -d -s $REST
tmux new-session -d -s $SSH
tmux new-session -d -s $NOTES
tmux new-session -d -s $CONF
tmux new-session -d -s $OTHER

# Here you can set up windows or panes for each of your sessions.
# For example, for WORK:

tmux new-window -t $NOTES:0 -n 'notes'
tmux send-keys -t $NOTES:0 'nvim -c ":Neorg index"' C-m
tmux select-window -t $NOTES:0 

tmux new-window -t $REST:0 -n 'rest'
tmux send-keys -t $REST:0 'pSql && nvim .' C-m
tmux select-window -t $REST:0 

tmux new-window -t $WORK:0 -n 'api'
tmux send-keys -t $WORK:0 'pApi' C-m

tmux new-window -t $WORK:1 -n 'ui'
tmux send-keys -t $WORK:1 'pUi' C-m

tmux select-window -t $WORK:0 


tmux new-window -t $CONF:0 -n 'nvim'
tmux send-keys -t $CONF:0 'pConf && cd astro-config' C-m

tmux new-window -t $CONF:1 -n 'wm'
tmux send-keys -t $CONF:1 'pConf && cd wm-config' C-m

tmux new-window -t $CONF:2 -n 'term'
tmux send-keys -t $CONF:2 'pConf && cd term-config' C-m


tmux select-window -t $CONF:0 

