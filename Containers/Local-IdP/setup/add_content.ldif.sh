#!/bin/bash

cat > /tmp/setup/add_content.ldif <<EOF
dn: ou=People,$KRB_LDAP_DN
objectClass: organizationalUnit
ou: People

dn: ou=Groups,$KRB_LDAP_DN
objectClass: organizationalUnit
ou: Groups

dn: cn=developers,ou=Groups,$KRB_LDAP_DN
objectClass: posixGroup
cn: developers
gidNumber: 5000
memberUid: $KRB_LDAP_TESTUSER_UID

dn: uid=$KRB_LDAP_TESTUSER_UID,ou=People,$KRB_LDAP_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: $KRB_LDAP_TESTUSER_UID
sn: Doe
givenName: John
cn: John Doe
displayName: John Doe
uidNumber: 10000
gidNumber: 5000
userPassword: $KRB_LDAP_TESTUSER_PASS
gecos: John Doe
loginShell: /bin/bash
homeDirectory: /home/$KRB_LDAP_TESTUSER_UID

dn: uid=$KRB_LDAP_TESTUSER_UID2,ou=People,$KRB_LDAP_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: $KRB_LDAP_TESTUSER_UID
sn: Doe
givenName: John
cn: Jane Doe
displayName: Jane Doe
uidNumber: 10001
gidNumber: 5001
userPassword: $KRB_LDAP_TESTUSER_PASS
gecos: Jane Doe
loginShell: /bin/bash
homeDirectory: /home/$KRB_LDAP_TESTUSER_UID2

dn: uid=$KRB_LDAP_TESTUSER_UID3,ou=People,$KRB_LDAP_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: $KRB_LDAP_TESTUSER_UID3
sn: Doe
givenName: Jibby
cn: Jibby Doe
displayName: Jibby Doe
uidNumber: 10002
gidNumber: 5002
userPassword: $KRB_LDAP_TESTUSER_PASS
gecos: Jibby Doe
loginShell: /bin/bash
homeDirectory: /home/$KRB_LDAP_TESTUSER_UID3
EOF