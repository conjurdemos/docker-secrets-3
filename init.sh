#!/bin/bash

conjur user create --as-group security_admin donna > donna.json
conjur group create --as-group security_admin developers
conjur group members add -a developers donna

apikey=$(cat donna.json | jsonfield api_key)
conjur authn login -p ${apikey} -u donna
