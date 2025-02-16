#!/bin/bash

PROJECT=$1
FILE=$2
LINE=$3
COL=$4

function send_to_server() {
	if [[ $LINE != 0 ]] || [[ $COL != 0 ]]; then
		nvim --server "$PROJECT/.godot.pipe" --remote-send "<C-\><C-N><cmd>e $FILE<CR><cmd>call cursor($LINE+1,$COL)<CR>";
	else
		nvim --server "$PROJECT/.godot.pipe" --remote-send "<C-\><C-N><cmd>e $FILE<CR>";
	fi
	wmctrl -xa "neovide.$PROJECT"
}

function start_neovide() {
	cd $PROJECT
	neovide "+call cursor($LINE, $COL)" $FILE --x11-wm-class "$(pwd)"
	cd -
}

send_to_server || start_neovide
