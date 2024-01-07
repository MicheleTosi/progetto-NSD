conf t
interface lo
 ip address 1.2.0.1/16
 ip address 1.255.0.4/32
interface eth0
 ip address 10.0.24.2/30
 mpls bgp forwarding
interface eth1
 ip address 10.0.45.1/30
 mpls bgp forwarding

router ospf
 router-id 1.255.0.4

 network 1.2.0.0/16 area 0
 network 1.255.0.4/32 area 0
 network 10.0.24.0/30 area 0
 network 10.0.45.0/30 area 0
exit

mpls ldp
 router-id 1.255.0.4
 ordered-control
 address-family ipv4
 discovery transport-address 1.255.0.4
 interface eth0
 interface eth1
 interface lo

end
