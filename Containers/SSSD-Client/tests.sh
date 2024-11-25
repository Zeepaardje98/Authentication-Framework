#!/bin/bash

run_test() {
    # Reset test results
    local message=""
    local result=""
    local wrapup=""
    local exit_code=0
    
    # The test function that will be evaluated
    local func_name="$2"
    # This should be the exit code of the function for the test to succeed
    local target_code="$1"

    shift
    shift

    # If function exists, run the test
    if declare -f "$func_name" > /dev/null; then
        "$func_name" "$@";
    fi
    
    # Run test and get exit code
    eval "$test > /dev/null 2>&1"
    local exit_code=$?

    # echo "$exit_code - $target_code"

    if [ $exit_code -ne $target_code ]; then
        status="FAILED"
    else
        status="SUCCESS"
        eval "$wrapup > /dev/null 2>&1"
    fi
    
    # Display if the test failed or succeeded, with the corresponding message
    echo "TEST $status: $message"
}

test_whoami() {
    local user="$1"

    # Authenticate as user (first param)
    echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$1@$KRB_REALM" > /dev/null 2>&1
    
    test="ldapwhoami -Y GSSAPI -H ldap://$LDAP_SERVICE_HOST"
    message="$1 can whoami"
    wrapup=""
}

test_search() {
    local user="$1"

    # Authenticate as user (first param)
    echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$1@$KRB_REALM" > /dev/null 2>&1
    
    test="ldapsearch -Y GSSAPI -H ldap://$LDAP_SERVICE_HOST -b $LDAP_DN"
    message="$1 can search $LDAP_DN"
    wrapup=""
}

test_modify() {
    local user="$1"

    # Authenticate as user (first param)
    echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$1@$KRB_REALM" > /dev/null 2>&1
    
    test="ldapadd -Y GSSAPI -H ldap://$LDAP_SERVICE_HOST -f /tmp/add_group.ldif"
    message="$1 can modify"
    wrapup="ldapmodify -Y GSSAPI -H ldap://$LDAP_SERVICE_HOST -f /tmp/del_group.ldif"
}

echo "----- RUN TESTS -----"

run_test 0 test_whoami $KRB_LDAP_TESTUSER_UID
run_test 0 test_whoami $KRB_LDAP_TESTUSER_UID2
run_test 0 test_whoami $KRB_LDAP_TESTUSER_UID3

run_test 0 test_modify $KRB_LDAP_TESTUSER_UID
run_test 0 test_modify $KRB_LDAP_TESTUSER_UID2
run_test 0 test_modify $KRB_LDAP_TESTUSER_UID3

run_test 0 test_search $KRB_LDAP_TESTUSER_UID
run_test 0 test_search $KRB_LDAP_TESTUSER_UID2
run_test 0 test_search $KRB_LDAP_TESTUSER_UID3

echo "-----    DONE   -----"