#!/bin/sh
#generating the consul.json file for the VM
prefix=$PREFIX

cat ../hcs/consul.json

export CONSUL_HTTP_TOKEN=$(cat ../hcs/mastertoken)

export CONSUL_HTTP_ADDR="$(cat ../hcs/consulurl | grep 'Consul url'| awk '{print $3}')"

cat ../hcs/consul.json | jq '.ca_file = "/etc/consul.d/ca.pem"' > consul_without_token.json
 
cat << EOF > client_vm_policy.hcl
node_prefix "$prefix-" {
  policy = "write"
}
node_prefix "" {
   policy = "read"
}
service_prefix "" {
   policy = "read"
}
EOF

consul acl policy delete -name consul-client-vm
consul acl policy create \
  -name consul-client-vm \
  -rules @client_vm_policy.hcl

consul acl token create \
  -description "consul-client vm token" \
  -policy-name consul-client-vm | tee client.token

client_token="$(cat client.token | grep SecretID  | awk '{print $2}')"

cat consul_without_token.json | jq '.acl.tokens.agent = "'"$client_token"'"' > consul.json
