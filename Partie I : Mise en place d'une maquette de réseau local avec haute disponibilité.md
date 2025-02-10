 ## Question 1.
 
En supposant que chaque sous-réseau est accessible via un routeur différent, chaque routeur aura une entrée pour chaque sous-réseau, y compris les routes par défaut et les routes vers les réseaux directement connectés.
Table de routage partielle pour R1 (15 routes pertinentes) :
- x9 : sous-réseau des autres étudiants
- x1 : sous-réseau de notre groupe (n°3)
- x1 : sous-réseau du professeur
- x1 : sous-réseau Vlan 633
- x1 : Vlan 140
- x1 : Vlan 176
- x1 : Route par défaut 

```
Réseau Destination | Next-hop | Coût | Explication 
10.100.4.0/24 | Directement Connecté | x | Route vers réseau interne étudiant | 
10.100.3.0/24 | Directement Connecté | x | Route vers le réseau de notre groupe |
10.200.9.0/24 | Directement Connecté | x | Route vers le réseau du prof |
10.250.0.0/24 | Directement Connecté | x | Route vers le Vlan 633 |
192.168.140.0/23 | 10.250.0.253 | x | Route vers le Vlan 140 |
192.168.176.0/24 | 10.250.0.254 | x |Route vers le Vlan 176 |
0.0.0.0/0 | 10.250.0.253 | x | Route par défaut | 

```

Table de routage partielle pour R2 (15 routes pertinentes) :
```
Réseau Destination | Next-hop | Coût | Explication 
10.100.4.0/24 | Directement Connecté | x | Route vers réseau interne étudiant | 
10.100.3.0/24 | Directement Connecté | x | Route vers le réseau de notre groupe |
10.200.9.0/24 | Directement Connecté | x | Route vers le réseau du prof |
10.250.0.0/24 | Directement Connecté | x | Route vers le Vlan 633 |
192.168.140.0/23 | 10.250.0.253 | x | Route vers le Vlan 140 |
192.168.176.0/24 | 10.250.0.254 | x |Route vers le Vlan 176 |
0.0.0.0/0 | 10.250.0.253 | x | Route par défaut | 
```
Ces tables de routage partielle incluent les routes directement connectées, les routes vers les autres sous-réseaux, et les routes par défaut.

## Question 2.

Le protocole VRRP (Virtual Router Redundancy Protocol) permet de créer un routeur virtuel en regroupant plusieurs routeurs physiques, assurant une redondance et une haute disponibilité. Il attribue une adresse IP virtuelle partagée par les routeurs, qui sert de passerelle par défaut pour les hôtes du réseau. En cas de défaillance d'un routeur, un autre routeur du groupe prend automatiquement le relais, garantissant une continuité de service sans interruption. Cela améliore la fiabilité du réseau en évitant les points de défaillance uniques.

## Question 3.

Le protocole VRRP (Virtual Router Redundancy Protocol) fonctionne en créant un groupe de routeurs qui partagent une adresse IP virtuelle. Cette adresse IP virtuelle est utilisée comme passerelle par défaut par les machines du réseau. Voici comment cela fonctionne en détail :

    Élection du Routeur Maître : Dans un groupe VRRP, un routeur est élu comme maître (Master) et les autres sont en mode backup. Le routeur maître est celui qui a la priorité la plus élevée (configurable). Il est responsable de l'envoi des paquets destinés à l'adresse IP virtuelle.

    Advertissements VRRP : Le routeur maître envoie régulièrement des messages VRRP (appelés advertisements) aux routeurs backup pour indiquer qu'il est toujours actif. Ces messages sont envoyés à intervalles réguliers (par défaut toutes les secondes).

    Détection de Défaillance : Si les routeurs backup ne reçoivent pas d'advertisements du routeur maître pendant un certain temps (défini par le temps d'attente, généralement trois fois l'intervalle d'advertisement), ils considèrent que le routeur maître est défaillant.

    Prise de Relais : Lorsqu'une défaillance est détectée, le routeur backup avec la priorité la plus élevée devient le nouveau routeur maître. Il commence à répondre aux paquets destinés à l'adresse IP virtuelle, assurant ainsi la continuité du service.

En cas de défaillance du routeur maître, un routeur de backup ayant la priorité la plus élevée prend le relais sur l'ancien maître, devenant le nouveau routeur maître du VRRP. Les utilisateurs, quant à eux, utilisent toujours la même adresse pour contacter le routeur. 

## Question 4.

Dans notre situation, OSPF permettrait aux routeurs R1 et R2 d'échanger des informations sur les réseaux disponibles (comme 10.X.Y.0/24, 10.250.0.0/24, et 192.168.176.0/24) et de calculer les routes les plus efficaces en fonction de la topologie du réseau.

L'utilisation du routage statique ne serait pas pertinente ici car elle nécessiterait une configuration manuelle des routes sur chaque routeur. Cela deviendrait rapidement complexe et peu flexible, surtout avec plusieurs VLANs (comme le Vlan 60(W), le Vlan 633, ou le Vlan 176) et des changements fréquents dans la topologie du réseau. OSPF, en revanche, s'adapte automatiquement aux changements, assurant une meilleure gestion des routes et une réduction des erreurs de configuration.


# CONFIGURATION ROUTEURS & MACHINE

### Routeur R1 :
Identifiants : admin@172.29.253.21:password 

Configuration : 
 - Déclaration LO ospf ;
 - Déclaration réseaux DC ;


## Question 5.
Sur A : 
Ping R1 : ping 10.100.3.252
-> Ping ok 
```
PING 10.100.3.252 (10.100.3.252) 56(84) octets de données.
64 octets de 10.100.3.252 : icmp_seq=2 ttl=255 temps=0.676 ms
```

## Question 6.

### Tests OSPF
SUR R1 :
'sh ip route' --> Resultat attendu : affichage de routes partagées via OSPF ;
```
do sh ip route
Codes: L - local, C - connected, S - static, R - RIP, M - mobile, B - BGP
       D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2, m - OMP
       n - NAT, Ni - NAT inside, No - NAT outside, Nd - NAT DIA
       i - IS-IS, su - IS-IS summary, L1 - IS-IS level-1, L2 - IS-IS level-2
       ia - IS-IS inter area, * - candidate default, U - per-user static route
       H - NHRP, G - NHRP registered, g - NHRP registration summary
       o - ODR, P - periodic downloaded static route, l - LISP
       a - application route
       + - replicated route, % - next hop override, p - overrides from PfR
       & - replicated local route overrides by connected

Gateway of last resort is 10.250.0.254 to network 0.0.0.0

O*E2  0.0.0.0/0 [110/10] via 10.250.0.254, 00:00:55, GigabitEthernet3
                [110/10] via 10.250.0.253, 00:00:55, GigabitEthernet3
      10.0.0.0/8 is variably subnetted, 7 subnets, 2 masks
C        10.10.3.1/32 is directly connected, Loopback1
O        10.100.2.0/24 [110/2] via 10.250.0.4, 00:00:55, GigabitEthernet3
C        10.100.3.0/24 is directly connected, GigabitEthernet2
L        10.100.3.252/32 is directly connected, GigabitEthernet2
O        10.200.1.0/24 [110/2] via 10.250.0.102, 00:00:55, GigabitEthernet3
C        10.250.0.0/24 is directly connected, GigabitEthernet3
L        10.250.0.5/32 is directly connected, GigabitEthernet3
      172.29.0.0/16 is variably subnetted, 2 subnets, 2 masks
C        172.29.253.0/24 is directly connected, GigabitEthernet1
L        172.29.253.21/32 is directly connected, GigabitEthernet1
O     192.168.140.0/23 [110/101] via 10.250.0.253, 00:00:55, GigabitEthernet3
O     192.168.176.0/24 [110/101] via 10.250.0.254, 00:00:55, GigabitEthernet3
```
On voit des routes ayant pour "code" O, ce qui signifie qu'OSPF est bien lancé. On detecte ainsi les déclaration OSPF des autres groupes (exemple : 10.100.2.0/24, ligne 19 du résultat de commande).


## Question 7.

Nos tests visent à démontrer que la transmission du rôle de Master entre les deux routeurs se passe comme prévu.

Scénario prévu : R1 est Master, et tombe. R2 Prend le relais et devient master.
Résultats :
```
G3-R1(config)#do sh vrrp
GigabitEthernet2 - Group 1
  State is Master
  Virtual IP address is 10.100.3.254
  Virtual MAC address is 0000.5e00.0101
  Advertisement interval is 1.000 sec
  Preemption enabled
  Priority is 110
  Master Router is 10.100.3.252 (local), priority is 110
  Master Advertisement interval is 1.000 sec
  Master Down interval is 3.570 sec
  FLAGS: 1/1
###########################################################
813-R2#show vrrp
GigabitEthernet2 - Group 1
  State is Backup
  Virtual IP address is 10.100.3.254
  Virtual MAC address is 0000.5e00.0101
  Advertisement interval is 1.000 sec
  Preemption enabled
  Priority is 100
  Master Router is 10.100.3.252, priority is 110
  Master Advertisement interval is 1.000 sec
  Master Down interval is 3.609 sec (expires in 2.891 sec)
  FLAGS: 0/1
###########################################################
G3-R1(config)#no vrrp 1
G3-R1(config-if)#do sh vrrp
G3-R1(config-if)#
###########################################################
813-R2#show vrrp
GigabitEthernet2 - Group 1
  State is Master
  Virtual IP address is 10.100.3.254
  Virtual MAC address is 0000.5e00.0101
  Advertisement interval is 1.000 sec
  Preemption enabled
  Priority is 100
  Master Router is 10.100.3.251 (local), priority is 100
  Master Advertisement interval is 1.000 sec
  Master Down interval is 3.609 sec
  FLAGS: 1/1
###########################################################
```
