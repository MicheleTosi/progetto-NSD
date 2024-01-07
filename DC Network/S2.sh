net del all

net add interface swp1 ip add 10.1.2.2/30
net add interface swp2 ip add 10.2.2.2/30
net add loopback lo ip add 5.5.5.5/32

net add ospf router-id 5.5.5.5
net add ospf network 0.0.0.0/0 area 0

net commit
