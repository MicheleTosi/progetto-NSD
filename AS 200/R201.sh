conf t
interface lo
ip address 2.2.0.1/16
ip address 2.255.0.2/32

interface eth0
ip address 10.0.20.2/30
interface eth1
ip address 10.0.12.1/30

router ospf
router-id 2.255.0.2

network 2.2.0.0/16 area 0
network 2.255.0.2/32 area 0
network 10.0.20.0/30 area 0

router bgp 200
network 2.2.0.0/16
neighbor 2.255.0.4 remote-as 200
neighbor 2.255.0.4 update-source 2.255.0.2
neighbor 2.255.0.4 next-hop-self

neighbor 10.0.12.2 remote-as 100
end
show ip route
show ip bgp