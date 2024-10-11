#!/bin/bash

cat > /tmp/kadm5.acl <<EOF
*/admin@$KRB_REALM        *
EOF