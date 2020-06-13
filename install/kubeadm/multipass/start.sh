#!/bin/bash
SECONDS=0

./list.sh | awk '{ print $1 }' | sed 's/^/multipass start /' | sh

printf '%d hour %d minute %d seconds\n' $((${SECONDS}/3600)) $((${SECONDS}%3600/60)) $((${SECONDS}%60))
