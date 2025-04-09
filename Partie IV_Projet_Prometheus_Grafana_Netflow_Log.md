# Partie IV : Projet Prometheus / Grafana / Netflow / Logs   
  
## Prometheus  
Prometheus se distingue comme l’un des outils les plus puissants et polyvalents pour la collecte et d’analyse de données en temps réel. Initialement développé par SoundCloud en 2012, il est depuis devenu l’un des outils de monitoring les plus populaires dans la communauté des développeurs.  
Prometheus : Un Outil de Monitoring Puissant et Polyvalent
Prometheus est un système open-source de monitoring et d’alerte conçu à l’origine par SoundCloud en 2012 et désormais maintenu par la Cloud Native Computing Foundation (CNCF).   
Il est particulièrement adapté au suivi des applications cloud-native et des infrastructures dynamiques.   
Prometheus est devenu un standard dans le monitoring des architectures modernes, notamment en association avec Kubernetes.

## Grafana 
Grafana est un outil open source de visualisation et d’analyse de données, très utilisé dans les environnements de supervision et de monitoring. Il permet de créer des tableaux de bord interactifs à partir de nombreuses sources de données comme Prometheus, InfluxDB, Elasticsearch, ou encore des bases SQL. L’un de ses points forts est sa capacité à afficher les métriques sous forme de graphiques, de jauges ou de tableaux en temps réel.  

Grâce à son interface web intuitive, Grafana facilite la surveillance des performances systèmes, réseaux ou applicatives. Il offre également des fonctionnalités d’alerting, permettant de définir des seuils et d’envoyer des notifications en cas de dépassement. Sa personnalisation avancée et sa gestion fine des utilisateurs en font un choix populaire pour les équipes DevOps, réseau ou sécurité.  

En résumé, Grafana est un outil puissant, flexible et esthétique, idéal pour transformer des données brutes en tableaux de bord clairs et exploitables.  

#  
L'arborescence final des fichiers de configuration de Prometheus et de Grafana est la suitante :    
.  
├── config  
│   └── [prometheus.yml](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/prometheus.yml)    
├── data  
├── [docker-compose.yml](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/docker-compose.yml)       
├── grafana  
├── snmp  
│   └── [snmp.yml](https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp.yml)  


Pour voir l'interface de snmp-exporter nous pouvons se rendre à l'adresse http://192.168.141.185:80  
Pour voir l'interface de grafana nous pouvons se rendre à l'adresse http://192.168.141.185:443  
Pour voir l'interface de prometheus nous pouvons se rendre à l'adresse http://192.168.141.185:9090  


## Test mis en place 
A l'aide d'iperf, nous allons réaliser des tests qui permerteront de vérifier le bon fonctionnement de la récupération de données via SNMP.  
Nous allons mettre la machine A en mode serveur : ```iperf3 -s````, puis sur la machine B nous lançons le script suivant :   
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

## Synthèse technique de Prometheus et des outils liés

### Introduction
Prometheus est un système de surveillance open source initialement développé par SoundCloud. Il est conçu pour collecter des métriques à partir de cibles configurées à des intervalles réguliers, stocker ces données efficacement, et fournir des outils de visualisation et d'alerte. Il repose sur un modèle de collecte *pull*, une base de données temporelle interne (TSDB) et un langage de requête puissant appelé PromQL. Dans un contexte d'ingénierie réseau et système, Prometheus permet une supervision fine des équipements, notamment via des exports SNMP.

### Architecture et fonctionnement de Prometheus
L'architecture de Prometheus repose sur plusieurs composants :
- **Prometheus Server** : le cœur du système, responsable de la collecte, du stockage des séries temporelles et de l'exécution des requêtes PromQL.
- **Exporters** : agents ou services exposant des métriques dans un format que Prometheus peut collecter. Pour le SNMP, on utilise `snmp_exporter`.
- **Alertmanager** : outil complémentaire à Prometheus permettant la gestion et la distribution des alertes (emails, Slack, webhook, etc.).
- **Service Discovery** : méthode permettant à Prometheus de découvrir automatiquement les cibles à superviser (DNS, fichiers statiques, etc.).
- **Grafana** : outil de visualisation puissant permettant de créer des dashboards dynamiques en interrogeant Prometheus via PromQL.

### Mise en place dans un environnement supervisé
Pour superviser un réseau comprenant des routeurs, les étapes techniques mises en œuvre sont les suivantes :

#### 1. Déploiement de Prometheus et Grafana via Docker Compose
Les services Prometheus et Grafana ont été définis dans un fichier `docker-compose.yml`. Les volumes permettent de persister les données et les fichiers de configuration, notamment :
- `prometheus.yml` : fichier principal de configuration listant les *targets* SNMP à superviser.
- Volumes Docker pour la persistance des données Prometheus et Grafana.

#### 2. Intégration du SNMP Exporter
Le `snmp_exporter` est configuré avec un fichier `snmp.yml` décrivant les OID à interroger, comme :
- `ifInOctets` et `ifOutOctets` (trafic entrant/sortant)
- `sysUpTimeInstance` (durée depuis le dernier redémarrage)

Ces informations sont récupérées sur les routeurs via SNMPv2c en utilisant la communauté `public`. 

#### 3. Création des dashboards dans Grafana
À partir des métriques exposées par `snmp_exporter`, plusieurs panels Grafana ont été configurés :
- Débit par interface réseau (calculé à partir des deltas `ifInOctets` / `ifOutOctets`)
- Noms des interfaces avec le trafic le plus élevé sur la dernière heure
- Statut VRRP actif/passif, via OID spécifiques à VRRP
- Affichage du `sysUptime` en jours/heures

#### 4. Évaluation et validation
Des tests ont été menés pour valider la bonne récupération des données SNMP, leur affichage en temps réel sur Grafana et la persistance des métriques dans Prometheus. Des scripts de test ont été rédigés pour simuler le trafic réseau et observer l’évolution des graphiques.

### Conclusion
L’intégration de Prometheus avec Grafana, combinée au `snmp_exporter`, fournit une solution robuste, modulaire et extensible pour la supervision réseau. Elle permet de visualiser en temps réel les performances des routeurs, détecter les anomalies, suivre les pannes, et exploiter efficacement les données SNMP. Ce système offre une base solide pour une surveillance proactive et automatisée d’une infrastructure réseau.

  
#### _Validation IX_
