## Partie IV : Projet Prometheus / Grafana / Netflow / Logs   
Dans un premier temps nous allons nous interreser à Prometheus.  
  
# Prometheus  
Prometheus se distingue comme l’un des outils les plus puissants et polyvalents pour la collecte et d’analyse de données en temps réel. Initialement développé par SoundCloud en 2012, il est depuis devenu l’un des outils de monitoring les plus populaires dans la communauté des développeurs.  
Prometheus : Un Outil de Monitoring Puissant et Polyvalent
Prometheus est un système open-source de monitoring et d’alerte conçu à l’origine par SoundCloud en 2012 et désormais maintenu par la Cloud Native Computing Foundation (CNCF).   
Il est particulièrement adapté au suivi des applications cloud-native et des infrastructures dynamiques.   
Prometheus est devenu un standard dans le monitoring des architectures modernes, notamment en association avec Kubernetes.




Mise en place de prometheus 

Sur B : 
Installation Docker et Docker compose : 
```sudo dnf install -y docker-compose ```

```bash
mkdir -p ~/prometheus/{data,config}
cd ~/prometheus
```

Dans ~/prometheus/config/prometheus/yml  
```yaml 
global:
  scrape_interval: 15s  # Fréquence de collecte des métriques

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "node-exporter"
    static_configs:
      - targets: ["node-exporter:9100"]

```

Dans ~/prometheus  
```
version: '3.8'
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./data:/prometheus
    ports:
      - "80:9090"
```
faire la commande suivante pour lancer le conteneur : 
```
docker compose up -d
```
Pour voir l'interface de prometheus nous pouvons se rendre à l'adresse 192.268.141.185 sur le port 80









