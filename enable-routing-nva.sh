sudo chmod 777 /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -d 10.0.0.0/8 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -d 172.16.0.0/12 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -d 192.168.0.0/16 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sudo iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
