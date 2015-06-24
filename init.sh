#!/bin/bash -e

# Notify demo started
REPORT=/tmp/report.sh
wget -q https://raw.githubusercontent.com/conjurinc/demo-factory/master/report.sh -O ${REPORT}
chmod a+x ${REPORT}
bash /tmp/report.sh docker-secrets-3

if ! conjur authn whoami &> /dev/null || [ $(conjur authn whoami | jsonfield username) != demo ]; then
  conjur authn login -u demo -p demo
fi

./init.rb

if [ $(conjur resource exists user:donna) = false ]; then
  conjur user create --as-group security_admin donna > donna.json
fi
if [ $(conjur resource exists group:developers) = false ]; then
  conjur group create --as-group security_admin developers
fi
conjur group members add -a developers donna

apikey=$(cat donna.json | jsonfield api_key)
conjur authn login -p ${apikey} -u donna
