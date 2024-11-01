#!/bin/bash

if [[ $BASH_SOURCE = */* ]];
then
    dir=${BASH_SOURCE%/*}
else 
    dir='.'
fi

docker build -t base-img $dir/Base
docker build -t base-openldap-img $dir/OpenLDAP