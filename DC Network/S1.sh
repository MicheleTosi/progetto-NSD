net del all

net add interface swp1 ip add 10.1.1.2/30
net add interface swp2 ip add 10.2.1.2/30
net add loopback lo ip add 4.4.4.4/32

net add ospf router-id 4.4.4.4
net add ospf network 0.0.0.0/0 area 0

net commit