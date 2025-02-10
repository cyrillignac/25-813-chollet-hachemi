 ###Question 1.
 
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

###Question 2
Le protocole VRRP (Virtual Router Redundancy Protocol) permet de créer un routeur virtuel en regroupant plusieurs routeurs physiques, assurant une redondance et une haute disponibilité. Il attribue une adresse IP virtuelle partagée par les routeurs, qui sert de passerelle par défaut pour les hôtes du réseau. En cas de défaillance d'un routeur, un autre routeur du groupe prend automatiquement le relais, garantissant une continuité de service sans interruption. Cela améliore la fiabilité du réseau en évitant les points de défaillance uniques.
