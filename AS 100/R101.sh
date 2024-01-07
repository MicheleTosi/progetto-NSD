conf t
interface lo
ip address 1.1.0.1/16
ip address 1.255.0.2/32

interface eth0
ip address 10.0.12.2/30
interface eth1
ip address 10.0.24.1/30
mpls bgp forwarding

router ospf
router-id 1.255.0.2
network 1.1.0.0/16 area 0
network 1.255.0.2/32 area 0
network 10.0.24.0/30 area 0
exit

mpls ldp
router-id 1.255.0.2
ordered-control
address-family ipv4
discovery transport-address 1.255.0.2
interface eth1
interface lo
exit

router bgp 100
network 1.1.0.0/16

neighbor 1.255.0.5 remote-as 100
neighbor 1.255.0.5 update-source 1.255.0.2
neighbor 10.0.12.1 remote-as 200

address-family ipv4
neighbor 1.255.0.5 activate
redistribute static
neighbor 1.255.0.5 next-hop-self
neighbor 10.0.12.1 next-hop-self
exit

end

show ip route
show ip bgp

quit
