conf t
interface lo
ip address 3.3.0.1/16
ip address 3.255.0.2/32

interface eth0
ip address 10.0.35.2/30
interface eth1
ip address 10.0.65.1/30

router ospf
router-id 3.255.0.2

network 3.3.0.0/16 area 0
network 3.255.0.2/32 area 0
network 10.0.65.0/30 area 0
exit

router bgp 300
network 3.3.0.0/16
neighbor 3.255.0.4 remote-as 300
neighbor 3.255.0.4 update-source 3.255.0.2
neighbor 3.255.0.4 next-hop-self

neighbor 10.0.35.1 remote-as 100
end

show ip route
show ip bgp
