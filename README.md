# Progetto 1

# Topologia
![Alt text](img/topologia.png)

## BGP
Per quanto riguarda gli AS configuriamo i vari nodi per scambiarsi messaggi con BGP.
> Aggiungere a ciascun file `start.sh` la riga di codice `vtysh < /etc/frr/progetto_NSD.sh`
Creare poi il file `/etc/frr/progetto_NSD.sh` in ciascun nodo con i seguenti comandi.

### AS 100
Iniziamo a configurare l'AS 100.

Prima di tutto configuriamo MPLS, OSPF, BGP.
Creiamo quindi questi file che chiamiamo `/etc/frr/progetto_NSD.sh` che verranno eseguiti come `vtysh < /etc/frr/progetto_NSD.sh` per configurare tutto.

- R101:
```bash
conf t
interface lo
ip address 1.1.0.1/16
ip address 1.255.0.2/32

interface eth0
ip address 10.0.12.2/30
interface eth1
ip address 10.0.24.1/30

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
neighbor 1.255.0.5 next-hop-self
redistribute static
exit

end
```

- R102:
```bash
conf t
interface lo
 ip address 1.2.0.1/16
 ip address 1.255.0.4/32
interface eth0
 ip address 10.0.24.2/30
interface eth1
 ip address 10.0.45.1/30

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
```

- R103:
```bash
conf t
interface lo
ip address 1.4.0.1/16
ip address 1.255.0.5/32

interface eth0
ip address 10.0.35.1/30

interface eth1
ip address 10.0.45.2/30

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
exit

end
```
Una volta fatto questo bisogna configurare l'input di MPLS sulle interfacce di ciascun router.
Creiamo il file `/etc/frr/sysctl.conf` in modo che ad ogni riavvio questo non venga eliminato, con i seguenti contenuti.

- R101:
```bash
net.mpls.conf.lo.input = 1
net.mpls.conf.eth1.input = 1
net.mpls.platform_labels = 100000
```
- R102:
```bash
net.mpls.conf.lo.input = 1
net.mpls.conf.eth0.input = 1
net.mpls.conf.eth1.input = 1
net.mpls.platform_labels = 100000
```
- R103:
```bash
net.mpls.conf.lo.input = 1
net.mpls.conf.eth1.input = 1
net.mpls.platform_labels = 100000
```

Ad ogni avvio per rendere queste configurazioni attive bisognerà invocare i seguenti comandi:
```bash
cp /etc/frr/sysctl.conf /etc/sysctl.conf
sysctl -p
```

### AS 200
In questo caso bisogna configurare solo BGP per il routing esterno e OSPF per quello interno.
Creiamo i file come mostrato prima.

- R201:
```bash
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
```
- R202
```bash
conf t
interface lo
ip address 2.4.0.1/16
ip address 2.255.0.4/32

interface eth1
ip address 10.0.20.1/30

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
```

**MANCA ANCORA 203**

### AS 300
- R301:
```bash
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
```
- R302:
```bash
conf t
interface lo
ip address 3.5.0.1/16
ip address 3.255.0.4/32

interface eth0
ip address 10.0.65.2/30
interface eth1
ip address 10.0.16.1/30

router ospf
router-id 3.255.0.4

network 3.5.0.0/16 area 0
network 3.255.0.4/32 area 0
network 10.0.65.0/30 area 0

router bgp 300
network 3.5.0.0/16
neighbor 3.255.0.2 remote-as 300
neighbor 3.255.0.2 update-source 3.255.0.4
neighbor 3.255.0.2 next-hop-self

neighbor 10.0.16.2 remote-as 400
end
```
**MANCA GW300**

### AS 400
- R401:
```bash
conf t
interface lo
 ip address 4.2.0.1/16

interface eth0
 ip address 10.0.16.2/30

router bgp 400
 network 4.2.0.1/16

 neighbor 10.0.16.1 remote-as 300
end
```
**MANCA ANCORA 402**

Una volta eseguiti questi comandi si può testare se funziona facendo il ping tra un nodo di un qualsiasi AS e un nodo di un altro AS (con i nodi di AS100 non funziona, da chiarire forse chiedendo consiglio a Tulux).
Per fare questo `ping <indirizzo_IP primo nodo> -I <indirizzo_IP secondo nodo>`.
Inoltre, si può controllare il contenuto delle tabelle bgp eseguendo ad esempio il comando `show ip bgp summary` in `vtysh`.

## DC Network
![Alt text](img/DC_Network.png)

Per creare la DC Network si è utilizzato il modello spine-leaf.

Una volta creati i nodi spines e i leaves con cumulus Linux (è stato utilizzato Cumulus Linux 4.1), questi sono stati configurati nel seguente modo:

- S1:
```bash
#per eliminare eventuali configurazioni errate già presenti nel nodo
net del all

net add interface swp1 ip add 10.1.1.2/30
net add interface swp2 ip add 10.2.1.2/30
net add loopback lo ip add 4.4.4.4/32

net add ospf router-id 4.4.4.4
net add ospf network 0.0.0.0/0 area 0

net commit
```

- S2:
```bash
net del all

net add interface swp1 ip add 10.1.2.2/30
net add interface swp2 ip add 10.2.2.2/30
net add loopback lo ip add 5.5.5.5/32

net add ospf router-id 5.5.5.5
net add ospf network 0.0.0.0/0 area 0

net commit
```

- L1:
```bash
net del all
net commit

net add bridge bridge ports swp3,swp4
net add interface swp3 bridge access 10
net add interface swp4 bridge access 20
net commit

net add interface swp1 ip add 10.1.1.1/30
net add interface swp2 ip add 10.1.2.1/30
net add loopback lo ip add 1.1.1.1/32
net commit

net add ospf router-id 1.1.1.1
net add ospf network 10.1.1.0/30 area 0
net add ospf network 10.1.2.0/30 area 0
net add ospf network 1.1.1.1/32 area 0
net add ospf passive-interface swp3,swp4
net commit

net add vxlan vni100 vxlan id 100
net add vxlan vni100 vxlan remoteip 2.2.2.2
net add vxlan vni100 vxlan local-tunnelip 1.1.1.1
net add vxlan vni100 bridge access 10
net add vxlan vni200 vxlan id 200
net add vxlan vni200 vxlan remoteip 2.2.2.2
net add vxlan vni200 vxlan local-tunnelip 1.1.1.1
net add vxlan vni200 bridge access 20

net commit
```

- L2:
```bash
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
```

I nodi client sotto ogni leaf sono stati configurati nel seguente modo:
- A1:
```bash
ip addr add 10.0.0.1/24 dev eth0
```

- A2:
```bash
ip addr add 10.0.0.2/24 dev eth0
```

- B1:
```bash
ip addr add 10.0.0.1/24 dev eth0
```

- B2:
```bash
ip addr add 10.0.0.2/24 dev eth0
```
