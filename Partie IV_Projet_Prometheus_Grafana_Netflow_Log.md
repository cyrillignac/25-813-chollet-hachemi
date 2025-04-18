# Partie IV : Projet Prometheus / Grafana / Netflow / Logs   
  
## Prometheus  
Prometheus se distingue comme l’un des outils les plus puissants et polyvalents pour la collecte et l’analyse de données en temps réel.
Initialement développé par SoundCloud en 2012, il est depuis devenu l’un des outils de monitoring les plus populaires dans la communauté des développeurs.

Prometheus : Un Outil de Monitoring Puissant et Polyvalent
Prometheus est un système open source de monitoring et d’alerte conçu à l’origine par SoundCloud en 2012 et désormais maintenu par la Cloud Native Computing Foundation (CNCF).
Il est particulièrement adapté au suivi des applications cloud-native et des infrastructures dynamiques.
Prometheus est devenu un standard dans le monitoring des architectures modernes, notamment en association avec Kubernetes.

## Grafana
Grafana est un outil open source de visualisation et d’analyse de données, très utilisé dans les environnements de supervision et de monitoring.
Il permet de créer des tableaux de bord interactifs à partir de nombreuses sources de données comme Prometheus, InfluxDB, Elasticsearch, ou encore des bases SQL.
L’un de ses points forts est sa capacité à afficher les métriques sous forme de graphiques, de jauges ou de tableaux en temps réel.

Grâce à son interface web intuitive, Grafana facilite la surveillance des performances systèmes, réseaux ou applicatives.
Il offre également des fonctionnalités d’alerting, permettant de définir des seuils et d’envoyer des notifications en cas de dépassement.
Sa personnalisation avancée et sa gestion fine des utilisateurs en font un choix populaire pour les équipes DevOps, réseau ou sécurité.

En résumé, Grafana est un outil puissant, flexible et esthétique, idéal pour transformer des données brutes en tableaux de bord clairs et exploitables.
#  
L'arborescence final des fichiers de configuration de Prometheus et de Grafana sur la machine B est la suitante :~/prometheus    
.  
├── config  
│   └── [prometheus.yml](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/prometheus.yml)    
├── data  
├── [docker-compose.yml](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/docker-compose_MachineB.yml)       
├── grafana  
├── snmp  
│   └── [snmp.yml](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp.yml)  


Pour voir l'interface de snmp-exporter nous pouvons se rendre à l'adresse http://192.168.141.185:9116  
Pour voir l'interface de grafana nous pouvons se rendre à l'adresse http://192.168.141.185:443 dans le Dashboard SNMP Stats  
Pour voir l'interface de prometheus nous pouvons se rendre à l'adresse http://192.168.141.185:80  


## Test mis en place 
À l'aide d'iPerf, nous allons réaliser des tests qui permettront de vérifier le bon fonctionnement de la récupération de données via SNMP.
Nous allons mettre la machine A en mode serveur : ```iperf3 -s```, puis sur la machine B, nous lançons le script suivant :  
```bash 
#!/bin/bash

SERVER_IP="$1"
DURATION=${2:-10}

if [ -z "$SERVER_IP" ]; then
  echo "Usage: $0 <SERVER_IP> [DURATION_IN_SECONDS]"
  exit 1
fi

echo "Test de débit vers $SERVER_IP pendant $DURATION secondes avec iperf3..."

iperf3 -c "$SERVER_IP" -t "$DURATION" --format m
```
Ce script envoit à l'aide d'iperf3 un débit d'environ 1Gbits/s.  
Nous pouvons voir sur cette capture que notre grafana nous remonte bien un débit d'environ 1Gbits/s sur la période du test.  
![image](https://github.com/user-attachments/assets/5fcadb13-12cc-41c7-b7b8-b8738b0e25b9)

#### _Validation VIII_
## Classement débit / VRRP
Pour cette partie, nous pouvons voir le classements des débits et certaines données des VRRP sur le Dashboard à l'adresse suivante : http://192.168.141.185:443/dashboards 

## **Synthèse technique approfondie : Prometheus et son écosystème de supervision**

### **Introduction**
Prometheus est une solution open source de surveillance et de métriques initialement conçue par SoundCloud. Il repose sur un modèle de collecte en mode *pull*, ce qui signifie qu'il interroge périodiquement les cibles surveillées afin de récupérer leurs métriques. Ces données sont stockées dans une base de données temporelle interne (TSDB) et peuvent être interrogées à l'aide du langage PromQL. Dans les environnements réseaux et systèmes, Prometheus s'avère extrêmement utile pour collecter et visualiser les performances d'équipements grâce, entre autres, à l'exploitation du protocole SNMP.

### **Architecture et composants**
L'architecture de Prometheus repose sur plusieurs briques fondamentales :

1. **Prometheus Server** : C'est le noyau central. Il se charge de la collecte des métriques, de leur stockage en séries temporelles, et de l'exécution des requêtes PromQL.

2. **Exporters** : Ce sont des composants qui exposent les métriques dans un format compatible Prometheus. Par exemple, `node_exporter` pour les machines Linux ou `snmp_exporter` pour les équipements réseau.

3. **Alertmanager** : Cet outil complémentaire permet de déclencher des alertes à partir de règles définies dans Prometheus. Il prend en charge la notification via e-mail, Slack, webhook, etc.

4. **Service Discovery** : Mécanisme qui permet à Prometheus de découvrir dynamiquement les cibles à superviser, via des fichiers statiques, DNS ou autres.

5. **Grafana** : Outil de visualisation qui permet de construire des tableaux de bord dynamiques, en interrogeant Prometheus via PromQL.

### **Mise en place dans un contexte réseau supervisé**

#### 1. **Déploiement via Docker Compose**
Prometheus, Grafana, et les exporters (comme snmp_exporter) sont déployés sous forme de conteneurs Docker. Le fichier `docker-compose.yml` décrit les services, les volumes pour la persistance des données et les ports exposés.

#### 2. **Configuration de Prometheus**
Le fichier `prometheus.yml` décrit les cibles à interroger via SNMP, avec des paramètres tels que les adresses IP des routeurs, la communauté SNMP, et les modules définis dans `snmp.yml`.

#### 3. **Utilisation du snmp_exporter**
Ce composant interroge les équipements réseau grâce au protocole SNMP. Le fichier `snmp.yml` contient la définition des OID à surveiller. Parmi les plus courants :
   - `ifInOctets`, `ifOutOctets` : pour surveiller le trafic entrant et sortant par interface
   - `sysUpTimeInstance` : pour connaître la durée de fonctionnement depuis le dernier redémarrage

#### 4. **Dashboards Grafana**
Des panels Grafana sont créés pour interpréter visuellement les métriques :
   - Surveillance du trafic réseau par interface (grâce aux taux de variation des octets)
   - Détection des interfaces les plus sollicitées
   - Affichage de l'état VRRP (actif ou passif) à l'aide des OID spécifiques
   - Suivi du `sysUpTime` pour vérifier les redémarrages intempestifs

#### 5. **Validation et tests**
Des tests fonctionnels sont réalisés afin de s'assurer que les métriques sont correctement collectées, stockées et affichées. Des scripts de génération de trafic permettent de simuler une activité réseau et d'observer la réactivité de l'ensemble de la chaîne de supervision.

### **Conclusion**
La combinaison de Prometheus, Grafana et snmp_exporter constitue une solution efficace, robuste et flexible pour la supervision d'infrastructures réseaux. Elle offre une vision en temps réel de l'état des équipements, permet une détection précoce des anomalies, et aide à maintenir un haut niveau de disponibilité des services. Cette architecture est parfaitement adaptée à des besoins de supervision automatisée et proactive dans des environnements professionnels ou académiques.
  
#### _Validation IX_

Après avoir mis en place un serveur nginx pour mettre en place des pages web. Ces pages web sont supérivisée à l'aide de Prometheus via node-exporter (la passerelle). Et nous avons une supervision graphique avec Grafana.

L'arborescence final des fichiers de configuration de la partie sur la machine A est la suitante :~/webserver    
.  
├── [docker-compose.yml](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/docker-compose_MachineA.yml)   
├── [nginx.conf](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/nginx.conf)  
├── [test_web](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/test_web.sh)  
└── website    
│   ├── [index.html](https://github.com/cyrillignac/25-813-chollet-hachemi/main/index_web.html)  
│   ├── [page1.html](https://github.com/cyrillignac/25-813-chollet-hachemi/main/page1.html)  
│   └── [page2.html](https://github.com/cyrillignac/25-813-chollet-hachemi/main/page2.html)



Voici la procédure qui permet de vérifier que le serveur web fonctionne. 
- Vérifier que le serveur web retourne bien les 3 pages :
   - Lancer un script qui vérifie que le "http code " d'un curl des pages soit 200 : [test-page-web](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/test_web.sh)
- Vérfier que Prometheus collecte bien les informations des targets :
    - Aller à l'adresse :  http://192.168.141.185/
    - Aller dans l'onglet Status -> Target
    - Regarder la target web-pages : il faut que le status soit "UP"
- Créer un dashboard simple avec up{job="web_server"} dans Grafana et le dashboard affiche bien des données.


 # Mise en place de Netflow 
 Pour des raisons de temps et parce que j’ai été seule à réaliser l’ensemble de la partie projet, je n’ai pas pu finaliser l’intégration de NetFlow dans mon infrastructure. Toutefois, j’ai mené des recherches approfondies sur sa mise en place. Les grandes étapes identifiées sont les suivantes :
1.    Activation de NetFlow sur les interfaces des deux routeurs que l’on souhaite superviser.

2.    Configuration de l’export des flux NetFlow vers un collecteur (adresse IP du serveur et port UDP, généralement 2055).

3.    Déploiement d’un collecteur NetFlow sur la machine B, via Docker ou une installation classique.

4.    Intégration et visualisation des données collectées sur Grafana, à travers des tableaux de bord dédiés.

5.    Vérification du bon fonctionnement de l’ensemble de la chaîne, accompagnée de tests de validation et de la création de dashboards affichant les statistiques de trafic réseau.
