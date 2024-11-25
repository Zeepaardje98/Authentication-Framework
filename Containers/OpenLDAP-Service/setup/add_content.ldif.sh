#!/bin/bash

cat > /tmp/add_content.ldif <<EOF
dn: ou=People,$LDAP_DN
objectClass: organizationalUnit
ou: People

dn: uid=$KRB_LDAP_TESTUSER_UID,ou=People,$LDAP_DN
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

dn: uid=$KRB_LDAP_TESTUSER_UID2,ou=People,$LDAP_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: $KRB_LDAP_TESTUSER_UID2
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

dn: ou=Groups,$LDAP_DN
objectClass: organizationalUnit
ou: Groups

dn: cn=gssapiGroup,ou=Groups,$LDAP_DN
objectclass: groupofNames
cn: gssapiGroup
member: uid=$KRB_LDAP_TESTUSER_UID,ou=People,$LDAP_DN
member: uid=$KRB_LDAP_TESTUSER_UID2,ou=People,$LDAP_DN

dn: cn=developers,ou=Groups,$LDAP_DN
objectclass: groupofNames
cn: developers
member: uid=$KRB_LDAP_TESTUSER_UID,ou=People,$LDAP_DN
EOF