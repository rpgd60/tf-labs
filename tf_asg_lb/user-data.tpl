#!/bin/bash

# Restart ssm-agent - sometimes it appears to be stuck
# systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service


export PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
export LOCAL_HOSTNAME=$(curl -s curl http://169.254.169.254/latest/meta-data/local-hostname)

cat > index.html <<EOF
<h1>Hola</h1>
<p>Public hostname : $LOCAL_HOSTNAME</p>
<p>Public IP : $PUBLIC_IP</p>
EOF

nohup busybox httpd -f -p ${port} &
