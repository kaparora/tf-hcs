#!/bin/bash

# sudo apt-get install -y unzip jq
set -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo apt update && sudo apt install -y unzip jq

CONSUL_ZIP="consul.zip"
CONSUL_URL="${consul_download_url}"
curl --silent --output /tmp/$${CONSUL_ZIP} $${CONSUL_URL}
unzip -o /tmp/$${CONSUL_ZIP} -d /usr/local/bin/
chmod 0755 /usr/local/bin/consul
chown azureuser:azureuser /usr/local/bin/consul
mkdir -pm 0755 /etc/consul.d
mkdir -pm 0755 /opt/consul
chown azureuser:azureuser /opt/consul


cat << EOF > /lib/systemd/system/consul.service
[Unit]
Description=Consul Client
Requires=network-online.target
After=network-online.target
[Service]
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /usr/local/bin/consul
ExecStart=/usr/local/bin/consul agent -config-dir="/etc/consul.d" -data-dir="/opt/consul"
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=azureuser
Group=azureuser
[Install]
WantedBy=multi-user.target
EOF

sudo cat << 'EOF' > /etc/consul.d/consul.json
${consul_json}
EOF

sudo cat << 'EOF' > /etc/consul.d/ca.pem
${ca_file}
EOF


sudo chmod 0664 /lib/systemd/system/consul.service
systemctl daemon-reload
sudo chown -R azureuser:azureuser /etc/consul.d
sudo chmod -R 0644 /etc/consul.d/*


systemctl enable consul
systemctl start consul
