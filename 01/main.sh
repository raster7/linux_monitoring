#!/bin/bash

ARG=$1

if  [[ $ARG =~ ^[0-9]+$ ]] || [[ $# -eq 0 ]]; then
    echo "error: Invalid input message" >&2;
    exit 1;
else
    echo $ARG;
fi
