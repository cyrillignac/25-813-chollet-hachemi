## Partie IV : Projet Prometheus / Grafana / Netflow / Logs   
Dans un premier temps nous allons nous interreser à Prometheus.  
  
# Prometheus  
Prometheus se distingue comme l’un des outils les plus puissants et polyvalents pour la collecte et d’analyse de données en temps réel. Initialement développé par SoundCloud en 2012, il est depuis devenu l’un des outils de monitoring les plus populaires dans la communauté des développeurs.  
Prometheus : Un Outil de Monitoring Puissant et Polyvalent
Prometheus est un système open-source de monitoring et d’alerte conçu à l’origine par SoundCloud en 2012 et désormais maintenu par la Cloud Native Computing Foundation (CNCF).   
Il est particulièrement adapté au suivi des applications cloud-native et des infrastructures dynamiques.   
Prometheus est devenu un standard dans le monitoring des architectures modernes, notamment en association avec Kubernetes.



L'arborescence final des fichiers de configuration de Prometheus et de Grafana est la suitante :    
.  
├── config  
│   └── prometheus.yml  
├── data  
├── docker-compose.yml  
├── grafana  
├── snmp  
│   └── snmp.yml  
  
Pour voir l'interface de prometheus nous pouvons se rendre à l'adresse 192.268.141.185 sur le port 80



