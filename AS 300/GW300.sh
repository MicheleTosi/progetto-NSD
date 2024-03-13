# VPN
#generiamo i certificati per OVPN
cd /usr/share/easy-rsa
./easyrsa init-pki
./easyrsa build-ca nopass

./easyrsa build-server-full GW300 nopass
./easyrsa build-client-full client-200 nopass
./easyrsa build-client-full R402 nopass

#generazione parametri DH
./easyrsa gen-dh

mkdir /root/CA
mkdir /root/CA/GW300
mkdir /root/CA/client-200
mkdir /root/CA/R402
cp /usr/share/easy-rsa/pki/ca.crt /root/CA/ #ca crt deve essere conosciuto da tutti
cp /usr/share/easy-rsa/pki/issued/GW300.crt /root/CA/server/ #server deve avere suo certificato
cp /usr/share/easy-rsa/pki/private/GW300.key /root/CA/server/
cp /usr/share/easy-rsa/pki/dh.pem /root/CA/server/
cp /usr/share/easy-rsa/pki/issued/client-200.crt /root/CA/client1/
cp /usr/share/easy-rsa/pki/private/client-200.key /root/CA/client1/
cp /usr/share/easy-rsa/pki/issued/R402.crt /root/CA/client2/
cp /usr/share/easy-rsa/pki/private/R402.key /root/CA/client2/
#adesso andiamo nella directory CA per copiare il materiale necessario sui client
cd /root/CA/
cat ca.crt #da qui copiamo certificato ca
cat client1/client-200.crt #basta copiare da begin a end certificate
cat client1/client-200.key
cat client2/R402.crt #basta copiare da begin a end certificate
cat client2/R402.key

#configurazione ip
ip a a 3.5.10.10/24 dev eth0

iptables -t nat -F
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

ip route add default via 3.5.10.1

ip addr add 10.3.3.1/24 dev eth1
ip route add 10.0.0.0/24 via 10.3.3.254 dev eth1
ip route add 10.1.1.0/24 via 10.3.3.254 dev eth1