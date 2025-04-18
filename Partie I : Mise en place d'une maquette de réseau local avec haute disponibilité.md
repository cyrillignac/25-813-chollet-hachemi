# Partie I : Mise en place d'une maquette de réseau local avec haute disponibilité
## 1. Schéma du réseau 
![Schema_réseau](https://github.com/user-attachments/assets/5e61bb51-a505-4fce-84ee-2fad75b33793)

## 2. Etude théorique préparatoire 

 ### **Question 1**
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

### Question 2
Le protocole VRRP (Virtual Router Redundancy Protocol) permet de créer un routeur virtuel en regroupant plusieurs routeurs physiques, assurant une redondance et une haute disponibilité. Il attribue une adresse IP virtuelle partagée par les routeurs, qui sert de passerelle par défaut pour des machines d'un réseau local. En cas de défaillance d'un routeur, un autre routeur du groupe prend automatiquement le relais, garantissant une continuité de service sans interruption. Cela améliore la fiabilité du réseau en évitant les points de défaillance uniques.

### Question 3.
Les routeurs vont se partager une adresse IP qualifiée de virtuelle. C'est cette adresse IP qui est configurée comme passerelle pardéfaut sur A et B.  
A un instant l'adresse IP virutelle est associée uniquiement à l'un des 2 routeurs, le routeur actif VRRP.  
Lorsqu'une machine interne (A ou B) veut envoyer une trame à l'exterieur, elle va émettre une requête ARP, seul le routeur assciée à l'adresse IP virtuelle y réonpondra et acheminera les paquets.  
Dans le cas de VRRP, les routeurs partagent en plus de l'adresse IP virtuelle, une adresse MAC virtuelle. Ainsi dans le cache ARP des machines on aura toujours la même association : @ip_vituelle => @MAC vituelle   
Avec cette adresse MAC virtuelle, les machines internes utilisent forcément le bon routeur VRRP.  
Pour que les trames venant des machines internes soient commauté jusqu'au "bon" routeur, il faut mettre à jou les tables de comutation de tous les switchs du réseau local. Pour cela, lorsqu"un routeur devient actif VRRP, il envoie une trame en broadcast avec comme adresse MAC-source l'adresse MAC virtuelle.

### Question 4.
Ici on a besoin du protocole OSPF pour mettre à jour la table de routage de RPROF1 en cas de défaillance de R1 ou de R2.  
Pour les machines internes, le protocole VRRP permet de choisir automatiquement le routeur actif. Il faut que RPROF1 sache à tout moment comment joindre le réseau interne.   
Avec du routage statique on aurait dans RPROF1 des routes :   
S | @réseau_interne | R1-externe   
S | @réseau_interne | R2-externe  
Si R1 ou R2 tombait en panne on perdrait 50% des flux réseaux.

## 3. CONFIGURATION ROUTEURS & MACHINE
Ici nous allons mettre en place et configurer A et R1. Les machines vituelles nous ont été données. 

### Question 5.
Pour tester le fonctionnement du réseau mise en place jusqu'à maitenant.  
Sur A :  
Ping R1 : ping 10.250.0.5  
-> Ping ok   
```bash
[etudiant@G3-813-A ~]$ ping 10.250.0.5
PING 10.250.0.5 (10.250.0.5) 56(84) octets de données.
64 octets de 10.250.0.5 : icmp_seq=2 ttl=255 temps=0.676 ms
```
Nous allons tester si depuis R1 on peut joindre RPROF1 et RPROF2 :    
Sur R1 : ping 10.250.0.253  
-> ping OK  
Sur R1 : ping 10.250.0.254  
-> ping OK   

### Question 6.
Tests OSPF
Pour tester la mise en place de OSPF nous allons tester la connectivité à internet :  
Sur A : ping 8.8.8.8
  
### Question 7.
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
G3-R1(config-if)# interface g2
G3-R1(config-if)# shutdown 
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
Après un shutdown de l'interface de R1.  
La VRRP coté R2, est devenu Master.   

Test 2 : ping internet depuis les machines clientes (A et B)
Sur A : Ping 8.8.8.8
-> Ping OK 
comportement prévu : ping réussi.

On remet l'interface active et on vérifie que tout continue de fonctionner.   
Il faut également testet lorsqu'on désactive l'interface externe du routeur actif. Dans cette configuration si A veut ping 8.8.8.8, R1 va communiquer avec R2 et R2 vers l'exterieur. 
