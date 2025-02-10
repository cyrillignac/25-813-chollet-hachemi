 ### Question 1.
 
En supposant que chaque sous-réseau est accessible via un routeur différent, chaque routeur aura une entrée pour chaque sous-réseau, y compris les routes par défaut et les routes vers les réseaux directement connectés.
Table de routage partielle pour R1 (7 routes pertinentes) :
```
10.100.3.0/24, Directement Connecté : Interface Interne ;
10.250.0.0/24, Directement Connecté : Interface Externe ;
10.100.2.0/24, Directement Connecté : Interface Externe ;
10.100.4.0/24, Directement Connecté : Interface Externe ;
192.168.140.0/23, Via 10.250.0.253 ;
192.168.176.0/24, Via 10.250.0.254 ;
0.0.0.0/0 : Route par défaut, Via 10.250.0.253/254 selon métrique ;

```

Table de routage partielle pour R2 (7 routes pertinentes) :
```
10.100.3.0/24, Directement Connecté : Interface Interne ;
10.250.0.0/24, Directement Connecté : Interface Externe ;
10.100.2.0/24, Directement Connecté : Interface Externe ;
10.100.4.0/24, Directement Connecté : Interface Externe ;
192.168.140.0/23, Via 10.250.0.253 ;
192.168.176.0/24, Via 10.250.0.254 ;
0.0.0.0/0 : Route par défaut, Via 10.250.0.253 ou .254 selon métrique ;
```
Ces tables de routage partielle incluent les routes directement connectées, les routes vers les autres sous-réseaux, et les routes par défaut.

### Question 2.

Le protocole VRRP (Virtual Router Redundancy Protocol) permet de créer un routeur virtuel en regroupant plusieurs routeurs physiques, assurant une redondance et une haute disponibilité. Il attribue une adresse IP virtuelle partagée par les routeurs, qui sert de passerelle par défaut pour les hôtes du réseau. En cas de défaillance d'un routeur, un autre routeur du groupe prend automatiquement le relais, garantissant une continuité de service sans interruption. Cela améliore la fiabilité du réseau en évitant les points de défaillance uniques.

### Question 3.

Le protocole VRRP (Virtual Router Redundancy Protocol) fonctionne en créant un groupe de routeurs qui partagent une adresse IP virtuelle. Cette adresse IP virtuelle est utilisée comme passerelle par défaut par les machines du réseau. Voici comment cela fonctionne en détail :

    Élection du Routeur Maître : Dans un groupe VRRP, un routeur est élu comme maître (Master) et les autres sont en mode backup. Le routeur maître est celui qui a la priorité la plus élevée (configurable). Il est responsable de l'envoi des paquets destinés à l'adresse IP virtuelle.

    Advertissements VRRP : Le routeur maître envoie régulièrement des messages VRRP (appelés advertisements) aux routeurs backup pour indiquer qu'il est toujours actif. Ces messages sont envoyés à intervalles réguliers (par défaut toutes les secondes).

    Détection de Défaillance : Si les routeurs backup ne reçoivent pas d'advertisements du routeur maître pendant un certain temps (défini par le temps d'attente, généralement trois fois l'intervalle d'advertisement), ils considèrent que le routeur maître est défaillant.

    Prise de Relais : Lorsqu'une défaillance est détectée, le routeur backup avec la priorité la plus élevée devient le nouveau routeur maître. Il commence à répondre aux paquets destinés à l'adresse IP virtuelle, assurant ainsi la continuité du service.

En cas de défaillance du routeur maître, un routeur de backup ayant la priorité la plus élevée prend le relais sur l'ancien maître, devenant le nouveau routeur maître du VRRP. Les utilisateurs, quant à eux, utilisent toujours la même adresse pour contacter le routeur. 
