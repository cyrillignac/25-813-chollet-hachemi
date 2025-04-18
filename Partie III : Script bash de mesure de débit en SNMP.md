# Partie III : Script bash de mesure de débit en SNMP
Durant cette partie, nous allons devoir développer un script Bash qui permet de mesurer les débits des flux entrants ou sortants d’un équipement.  
Par exemple, notre script doit permettre de connaître le débit sortant d'une interface d'un routeur, avec un relevé effectué toutes les minutes sur une très longue période. Les mesures de débit sont stockées dans un fichier.  
On fixe comme périodicité minimale de la mesure 1 minute, et comme périodicité maximale 30 minutes. Nous allons écrire un script sur la machine Linux.  

### Question 18 : 
La fonction sleep est un processus qui reste en cours d'exécution en arrière-plan. Si le processus est tué ou si le système redémarre, le script ne redémarrera pas automatiquement, contrairement à cron ou systemd
Le processus sleep reste actif même si il n'est pas utilisé, cela consomme de la mémoire et du CPU. Contrairement au job cron ou un timer systemd, ne lance le script que lorsqu'il est nécessaire.

Nous allons donc utiliser cron ou les timers systemd dans notre cas à la place du processus sleep

## 1. Récupération du compteur d'octets

Première version du script : 
<a href="https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp-1.sh"> script-snmp-1  

Résultat de la commande :   
```Valeur du compteur d’octets de l’interface 3 : 24657423 ```

>> Explication des options de snmpget :
-v2c → Utilisation de SNMP version 2c.  
-c "$community" → Spécifie la communauté SNMP.  
"$agent_ip" "$oid" → Adresse de l’équipement et OID interrogé.  

Deuxième version du script (timestamps + stockage fichier) :
<a href="https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp-2.sh"> script-snmp-2  

Résultat de la commande : cat throughput_int1.txt
```
1741859703;10474886
1741861778;10523085;185
1741861789;10523591;368
1741867126;10645180;182
1742290714;24652165;264
1742291014;24662806;283
1742291020;24663062;341
```

## 2. Gestion de la date et enregistrement des résultats dans un fichier
L’option de la commande date qui permet d’afficher la date au format nombre de secondes écoulées depuis 01/01/1970 est la suivante :  
```date +%s``` dans la commande ```date +%s```  

>> "$filename" → Ajoute la ligne à la fin du fichier sans l’écraser.
Format de stockage : timestamp valeur_octets (exemple : 1710212345;34499394).

## 3. Lecture de la dernière ligne du fichier, calcul et enregistrement du débit

### Question 19 : procédure de tests
Voici une procedure de vérification pour s'assurer que notre code fonctionne correctement.

Verfication 1 : Récupération des données SNMP  
1) Sur B : Exécuter le script : ```./snmp-2.sh``` et ```cat throughput_int1.txt```
2) Vérifier que la valeur recupérée est correcte et qu'aucune erreur n'est retournée.
3) Comparer le résultat avec une exécution manuelle de la commande SNMP correspondante  
  
Verfication 2 : Enregistrement dans un fichier 
1) vérifier le contenu du fichier avant le lancement du script
2) Lancer le script
3) Vérifier qu'une ligne à bien été ajoutée à la fin sans écraser les autres lignes déjà existantes.
  
Verfication 3 : Conrôle de l'horodatage  
1) Lancer le script et regarde la colonne lié à la date  
2) Lancer la commande ``` date+%s```  
3) Comparer les deux valeurs, elles doivent être presque identique à quelque seconde près.

### Validation VI

## 4. Gestion du fichier vide et gestion du rebouclage du compteur d’octets.
Dans cette partie nous allons améloirer notre script, ce dernier devra gérer la première exécution (aucune donnée dans le ficiher).  

Version 3 du script : gestion des erreurs et du premier lancement :  <a href="https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp-3.sh"> Script-snmp3

### Question 20 : 

Le problème posé par le bouclage du compteur est l'obtention lors de deux mesures successives de valeurs moins elevées au fil du temps, ce qui n'est pas logique et qui donnerait un débit négatif. Afin de corriger ce problème, on peut intégrer cette "équation" : 
```
diff_mesure = (MAX_COUNTER - valeur_précédente) + valeur_actuelle
```
la valeur MAX_COUNTER représente la valeur maximale que le compteur peut recevoir (2^32 pour le compteur a 32 bits et 2^64 pour celui à 64)
Afin d'obtenir une deuxième valeur précise, on va soustraire à la valeur maximale du compteur la valeur de notre mesure précédente, puis y ajouter la valeur actuelle après bouclage, ce qui nous donnera un résultat exact. 
  
Version du script : rebouclage    
<a href="https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp-4.sh"> script-snmp-4-rebouclage

## 5. Utilisation du cron pour que le script s’exécute toutes les minutes

### Question 21 : Utilisation de Cron 
Dans cette partie nous allons mettre en place Cron pour executer notre script toutes les minutes. 

Dans un premier temps nous avons déplacer notre script snmp-4.sh dans le dossier : /usr/local/bin/  
Dans un second temps nous avons créé un fichier ```monitoring.log``` pour stocker nos log dans le dossier : /var/log/snmp/  
Puis nous avons créer un cron à l'aide de la commande suivante :
```
crontab -e
```  
Dans le fichier cron nous avons mis la ligne suivante   
```
* * * * * /usr/local/bin/snmp-4.sh >> /var/log/snmp/monitoring.log 2>&1
```  
Explication   
```"* * * * *"``` rend le fichier executable toutes les minutes ;  
```"/usr/local/bin/snmp-monitor.sh"``` chemin absolu du script ;  
```">> /var/log/snmp_monitor.log"``` sors les resultats dans le fichier de log ;  
```"2>&1"``` stocke les erreurs vers le fichier de log ;  

Phase de vérification :  Nous faisons les commandes suivantes : 

```crontab -l``` pour vérifier que le script est bien en execution, on doit avoir notre ligne ajoutée.    

```tail -f /var/log/snmp_monitor.log``` pour vérifier les lignes de log en temps réel.  

Tous ces opérations ont été faites en sudo.  
Je rappelle l'adresse IP de la machine hébergeant les scripts est : 192.168.141.185 ou 172.29.253.25/24 sur le serv21   
Avec comme mot de passe : password.  

### Validation VII

## 6. Script générique 
### Question 22 : Script Générique 
Version du script : Générique    
<a href="https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp_generic.sh"> script-snmp_generic  

Ainsi dans le cron nous avons rajouté la ligne suivante :   
```
* * * * * /usr/local/bin/snmp_generic.sh 10.100.3.254 123test123 3 throughput_int3.txt >> /var/log/snmp/monitoring.log 2>&1
```  
