conf t
interface lo
ip address 2.4.0.1/16
ip address 2.255.0.4/32

interface eth1
ip address 10.0.20.1/30

interface eth0
ip address 2.4.10.1/24

router ospf
router-id 2.255.0.4

network 2.4.0.0/16 area 0
network 2.255.0.4/32 area 0
network 10.0.20.0/30 area 0

router bgp 200
network 2.4.0.0/16
neighbor 2.255.0.2 remote-as 200
neighbor 2.255.0.2 update-source 2.255.0.4
neighbor 2.255.0.2 next-hop-self

end
exit
