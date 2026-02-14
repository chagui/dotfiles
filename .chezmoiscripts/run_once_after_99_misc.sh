#!/bin/bash

mkdir -p "${XDG_STATE_HOME:-$HOME/.state}/zsh/"
bat cache --build
tldr --update
