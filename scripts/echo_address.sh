NODE_IP=$(ip addr show eth0 | grep -w "inet" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | head -n1)

echo -e "IP address: $NODE_IP"
