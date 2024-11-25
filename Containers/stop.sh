#!/bin/bash

if [[ $BASH_SOURCE = */* ]];
then
    dir=${BASH_SOURCE%/*}
else 
    dir='.'
fi

docker-compose --project-directory $dir down -v