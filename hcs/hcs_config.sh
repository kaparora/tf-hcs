#!/bin/sh
prefix=$PREFIX
resource_group_name="${prefix}-hcs"
application_name="${prefix}hcsapp"

az extension add -y \
  --source https://releases.hashicorp.com/hcs/0.1.0/hcs-0.1.0-py2.py3-none-any.whl


az hcs get-config \
  --resource-group $resource_group_name \
  --name $application_name

cat consul.json

az hcs create-token \
  --resource-group $resource_group_name \
  --name $application_name > mastertokenoutput

cat mastertokenoutput | jq -r .masterToken.secretId > mastertoken
export CONSUL_HTTP_TOKEN=$(cat mastertoken)

az hcs browse \
--resource-group $resource_group_name \
  --name $application_name \
  --show-uri | tee consulurl
export CONSUL_HTTP_ADDR="$(cat consulurl | grep 'Consul url'| awk '{print $3}')"