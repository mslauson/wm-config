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
# tmux new-session -d -s $NOTES
tmux new-session -d -s $CONF
tmux new-session -d -s $OTHER

# Here you can set up windows or panes for each of your sessions.
# For example, for WORK:

# tmux new-window -t $NOTES:0 -n 'notes'
# tmux select-window -t $NOTES:0

# tmux new-window -t $REST:0 -n 'rest'
# tmux send-keys -t $REST:0 'pRest' C-m
# tmux select-window -t $REST:0
#
tmux send-keys -t $WORK:0 'pApi' C-m

tmux send-keys -t $CONF:0 'pConf' C-m
