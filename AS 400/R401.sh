conf t
interface lo
 ip address 4.2.0.1/16

interface eth0
 ip address 10.0.16.2/30

router bgp 400
 network 4.2.0.1/16

 neighbor 10.0.16.1 remote-as 300
end
