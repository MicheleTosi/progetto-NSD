ip a a 192.168.2.2/24 dev eth1
ip a a 4.2.10.10/24 dev eth0

iptables -t nat -F
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

ip route add default via 4.2.10.1