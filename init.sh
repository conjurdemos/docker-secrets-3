#!/bin/bash

conjur group create security_admin
conjur group members add security_admin admin

conjur user create --as-group security_admin donna > donna.json
conjur group create --as-group security_admin developers
conjur group members add -a developers donna

apikey=$(cat donna.json | jsonfield api_key)
echo $apikey | conjur authn login -u donna
