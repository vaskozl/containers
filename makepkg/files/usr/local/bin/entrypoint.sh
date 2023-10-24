#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 [command] [arguments]"
    echo "Please provide a command to execute."
else
    exec "$@"
fi
