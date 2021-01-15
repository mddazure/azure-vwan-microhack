sudo chmod 777 /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
# sudo  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE