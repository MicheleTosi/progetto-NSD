net del all
net commit

net add bridge bridge ports swp3, swp4
net add interface swp3 bridge access 10
net add interface swp4 bridge access 20

net add interface swp1 ip add 10.2.1.1/30
net add interface swp2 ip add 10.2.2.1/30
net add loopback lo ip add 2.2.2.2/32

net add ospf router-id 2.2.2.2
net add ospf network 10.2.1.0/30 area 0
net add ospf network 10.2.2.0/30 area 0
net add ospf network 2.2.2.2/32 area 0
net add ospf passive-interface swp3,swp4

net add vxlan vni100 vxlan id 100
net add vxlan vni100 vxlan remoteip 1.1.1.1
net add vxlan vni100 vxlan local-tunnelip 2.2.2.2
net add vxlan vni100 bridge access 10
net add vxlan vni200 vxlan id 200
net add vxlan vni200 vxlan remoteip 1.1.1.1
net add vxlan vni200 vxlan local-tunnelip 2.2.2.2
net add vxlan vni200 bridge access 20

net commit
