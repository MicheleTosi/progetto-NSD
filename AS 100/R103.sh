conf t
interface lo
ip address 1.4.0.1/16
ip address 1.255.0.5/32

interface eth0
ip address 10.0.35.1/30

interface eth1
ip address 10.0.45.2/30
mpls bgp forwarding
router ospf
router-id 1.255.0.5

network 1.4.0.0/16 area 0
network 1.255.0.5/32 area 0
network 10.0.45.0/30 area 0
exit

mpls ldp
router-id 1.255.0.5
ordered-control
address-family ipv4
discovery transport-address 1.255.0.5
interface eth1
interface lo
exit

router bgp 100
 network 1.4.0.0/16

 neighbor 1.255.0.2 remote-as 100
 neighbor 1.255.0.2 update-source 1.255.0.5
 neighbor 10.0.35.2 remote-as 300

address-family ipv4
 neighbor 1.255.0.2 activate
 redistribute static
 neighbor 1.255.0.2 next-hop-self
 neighbor 10.0.35.2 next-hop-self
exit

end

show ip route
show ip bgp