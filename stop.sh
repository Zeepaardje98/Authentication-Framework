#!/bin/bash

# Get source of bash execution
if [[ $BASH_SOURCE = */* ]];
then
    dir=${BASH_SOURCE%/*}
else 
    dir='.'
fi

# Stop containers
bash "$dir/Containers/stop.sh"