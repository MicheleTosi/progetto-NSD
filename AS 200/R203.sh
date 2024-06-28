ip a a 192.168.1.1/24 dev eth0
ip a a 2.4.10.10/24 dev eth1

iptables -t nat -F
echo 1 > /proc/sys/net/ipv4/ip_forward

export LAN=eth0
export WAN=eth1

iptables -F
iptables -P FORWARD DROP
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT

iptables -A FORWARD -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $LAN -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i $LAN -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -i $LAN -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -i $LAN -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -i $LAN -p udp --dport 1194 -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i $LAN -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i $WAN -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i $LAN -p udp --dport 1194 -j ACCEPT
iptables -A FORWARD -p icmp -j ACCEPT

iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

ip route add default via 2.4.10.1
