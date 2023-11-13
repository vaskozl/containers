#!/bin/bash
set -e

# Define escape to make the script pretty
RED='\e[31m'
BLUE='\e[34m'
BOLD='\e[1m'
RESET='\e[0m'

if [ "$(id -u)" -eq 0 ]; then
  echo -e "${RED}WARN${RESET}: Running as the ${BOLD}root${RESET} user."
else
  echo -e "${BLUE}INFO${RESET}: Running as UID=$(id -u) and GID=$(id -g)"
fi

# If there are no arguments run $EXEC as is
if [ $# -eq 0 ]; then
  set -- $EXEC

# Predend the binary from $EXEC if command with flags
elif [ "${1:0:1}" = '-' ]; then
  bin="${EXEC%% *}"  # Extract the first word from EXEC
  set -- "$bin" "$@"
fi



if [ $# -eq 0 ]; then
    echo "Usage: $0 [command] [arguments]"
    echo "Please provide a command to execute."
else
    echo -e "${BLUE}INFO${RESET}: Executing $@"
    exec "$@"
fi
