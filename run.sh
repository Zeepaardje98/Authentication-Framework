#!/bin/bash

# Get source of bash execution
if [[ $BASH_SOURCE = */* ]];
then
    dir=${BASH_SOURCE%/*}
else 
    dir='.'
fi

# Build base Images
bash "$dir/BaseImages/create_base_imgs.sh"

# Build images and run containers
bash "$dir/Containers/build_start.sh"
