#!/bin/bash

cat > /tmp/setup/kadm5.acl <<EOF
*/admin@$KRB_REALM        *
EOF