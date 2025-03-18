![Schema_réseau](https://github.com/user-attachments/assets/5e61bb51-a505-4fce-84ee-2fad75b33793)

 ## Question 1.
 
En supposant que chaque sous-réseau est accessible via un routeur différent, chaque routeur aura une entrée pour chaque sous-réseau, y compris les routes par défaut et les routes vers les réseaux directement connectés.
Nous avons 47 routes présentes dans R1 et R2.
- x10 : sous-réseau des autres étudiants + profs ( le réseau interne est accessible via 2 chemins aquidistants => 20 lignes pour chaque réseau interne
- x1 : sous-réseau de notre groupe (n°3)(DC)
- x1 : sous-réseau Vlan 633 (DC)
- x1 : Vlan 140
- x1 : Vlan 176
- x2 : Route par défaut
- (x1 : loopback)
- x20 loopback de chaque routeur 
  
On utilise ici pour le coût le protocole OSPF. Le coût est calculé de la façon suivante :  
coût = (débit_reference)/débit du lien   
débit_reference = 10 Gbits/s

**__➡️Table de routage partielle pour R1 (7 routes pertinentes)⬅️__**
| Réseau Destination  | Next-hop               | Coût | Explication                         |
|---------------------|:---------------------:|------|:-----------------------------------:|
| 10.100.3.0/24      | Directement Connecté g2  |  x  | Route vers réseau de notre groupe |
| 10.250.0.0/24      | Directement Connecté g3  | x    | Route vers le VLAN 633            |
| 10.10.3.0/24       | Directement Connecté lo  | x    | Route vers le réseau du prof       |
| 10.100.4.0/24      | 10.250.0.x             | 20    | Route vers réseau interne étudiant |
|      ....          | 10.250.0.x             | 20    | Route vers réseau interne étudiant |
| 192.168.140.0/23   | 10.250.0.253           | 20    | Route vers le Vlan 140             |
| 192.168.176.0/24   | 10.250.0.254           | 20    | Route vers le Vlan 176             |
| 0.0.0.0/0          | 10.250.0.253           | x     | Route par défaut                   |
| 0.0.0.0/0          | 10.250.0.254           | x     | Route par défaut                   |



**__➡️Table de routage partielle pour R2 (7 routes pertinentes)⬅️__**
| Réseau Destination | Next-hop              | Coût | Explication                         |
|--------------------|:--------------------:|------|:-----------------------------------:|
| 10.100.3.0/24      | Directement Connecté g2  |  x  | Route vers réseau de notre groupe |
| 10.250.0.0/24      | Directement Connecté g3  | x    | Route vers le VLAN 633            |
| 10.10.3.0/24       | Directement Connecté lo  | x    | Route vers le réseau du prof       |
| 10.100.4.0/24      | 10.250.0.x             | 20    | Route vers réseau interne étudiant |
|      ....          | 10.250.0.x             | 20    | Route vers réseau interne étudiant |
| 192.168.140.0/23   | 10.250.0.253           | 20    | Route vers le Vlan 140             |
| 192.168.176.0/24   | 10.250.0.254           | 20    | Route vers le Vlan 176             |
| 0.0.0.0/0          | 10.250.0.253           | x     | Route par défaut                   |
| 0.0.0.0/0          | 10.250.0.254           | x     | Route par défaut                   |

Ces tables de routage partielle incluent les routes directement connectées, les routes vers les autres réseaux internes, et les routes par défaut.

## Question 2.

Le protocole VRRP (Virtual Router Redundancy Protocol) permet de créer un routeur virtuel en regroupant plusieurs routeurs physiques, assurant une redondance et une haute disponibilité. Il attribue une adresse IP virtuelle partagée par les routeurs, qui sert de passerelle par défaut pour des machines d'un réseau local. En cas de défaillance d'un routeur, un autre routeur du groupe prend automatiquement le relais, garantissant une continuité de service sans interruption. Cela améliore la fiabilité du réseau en évitant les points de défaillance uniques.

## Question 3.
Les routeurs vont se partager une adresse IP qualifiée de virtuelle. C'est cette adresse IP qui est configurée comme passerelle pardéfaut sur A et B.  
A un instant l'adresse IP virutelle est associée uniquiement à l'un des 2 routeurs, le routeur actif VRRP.  
Lorsqu'une machine interne (A ou B) veut envoyer une trame à l'exterieur, elle va émettre une requête ARP, seul le routeur assciée à l'adresse IP virtuelle y réonpondra et acheminera les paquets.  
Dans le cas de VRRP, les routeurs partagent en plus de l'adresse IP virtuelle, une adresse MAC virtuelle. Ainsi dans le cache ARP des machines on aura toujours la même association : @ip_vituelle => @MAC vituelle   
Avec cette adresse MAC virtuelle, les machines internes utilisent forcément le bon routeur VRRP.  
Pour que les trames venant des machines internes soient commauté jusqu'au "bon" routeur, il faut mettre à jou les tables de comutation de tous les switchs du réseau local. Pour cela, lorsqu"un routeur devient actif VRRP, il envoie une trame en broadcast avec comme adresse MAC-source l'adresse MAC virtuelle.

## Question 4.

Ici on a besoin du protocole OSPF pour mettre à jour la table de routage de RPROF1 en cas de défaillance de R1 ou de R2.  
Pour les machines internes, le protocole VRRP permet de choisir automatiquement le routeur actif. Il faut que RPROF1 sache à tout moment comment joindre le réseau interne.   
Avec du routage statique on aurait dans RPROF1 des routes :   
S | @réseau_interne | R1-externe   
S | @réseau_interne | R2-externe  
Si R1 ou R2 tombait en panne on perdrait 50% des flux réseaux.

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
```bash
[etudiant@G3-813-A ~]$ ping 10.100.3.252
PING 10.100.3.252 (10.100.3.252) 56(84) octets de données.
64 octets de 10.100.3.252 : icmp_seq=2 ttl=255 temps=0.676 ms
```

## Question 6.

### Tests OSPF
SUR R1 :
'sh ip route' --> Resultat attendu : affichage de routes partagées via OSPF ;
```bash
G3-R1(config)# do sh ip route
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
```bash
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

Test 2 : ping sur l'adresse virtuelle du VRRP depuis les machines clientes (A et B)
Sur A : Ping 10.100.3.254 (@VRRP)
-> Ping OK 
comportement prévu : ping réussi.
