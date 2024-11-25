#!/bin/bash

if [[ $BASH_SOURCE = */* ]];
then
    dir=${BASH_SOURCE%/*}
else 
    dir='.'
fi

# docker build --no-cache -t base $dir/Base
# docker build --no-cache -t base-openldap $dir/OpenLDAP
# docker build --no-cache -t base-openldap-sync $dir/OpenLDAP-Sync

docker build -t base $dir/Base
docker build -t base-openldap $dir/OpenLDAP
docker build -t base-openldap-sync $dir/OpenLDAP-Sync