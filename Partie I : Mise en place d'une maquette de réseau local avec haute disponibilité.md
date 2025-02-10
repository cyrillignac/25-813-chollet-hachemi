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

