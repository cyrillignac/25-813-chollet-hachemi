Durant cette partie nous allons devoir développer un script Bash qui permet de mesurer les débits des flux entrant ou sortant d’un équipement. 
Par exemple, notre script doit permettre de connaître le débit sortant d'une interface d'un routeur, avec un relevé effectué toutes les minutes sur une très longue période.
Les mesures de débit sont stokées dans un fichier.

On fixe comme prériodicité minimale de la mesure 1 minutes et comme périodicité maximale 30 mintutes.
Nous allons écrire un script sur la machine linux.

## Question 18 : 
La fonction sleep est un processus qui reste en cours d'exécution en arrière-plan. Si le processus est tué ou si le système redémarre, le script ne redémarrera pas automatiquement, contrairement à cron ou systemd
Le processus sleep reste actif même si il n'est pas utilisé, cela consomme de la mémoire et du CPU. Contrairement au job cron ou un timer systemd, ne lance le script que lorsqu'il est nécessaire.

Nous allons donc utilisé cron ou les timers systemd dans notre à la place du processus sleep

## 

Première version du script : 
<a href="https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp-1.sh"> script-snmp-1   
Résultat de la commande : 
```Valeur du compteur d’octets de l’interface 3 : 24657423```

>> Explication des options de snmpget :
-v2c → Utilisation de SNMP version 2c.  
-c "$community" → Spécifie la communauté SNMP.  
"$agent_ip" "$oid" → Adresse de l’équipement et OID interrogé.  

Deuxième version du script (timestamps + stockage fichier) :
<a href="https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/snmp-2.sh"> script-snmp-2  
Résultat de la commande : cat throughput_int1.txt
```` 1741859703;10474886
1741861778;10523085;185
1741861789;10523591;368
1741867126;10645180;182
1742290714;24652165;264
1742291014;24662806;283
1742291020;24663062;341```


>> "$filename" → Ajoute la ligne à la fin du fichier sans l’écraser.
Format de stockage : timestamp valeur_octets (exemple : 1710212345;34499394).

## Question 19 : procédure de tests

Test récupération données snmp : 

Lancer le script sur une des machines client --> le script doit récupérer une valeur et ne retourner aucune erreur
Comparer avec la commande manuelle

Vérification enregistrement dans fichier : 
Lancer le script et vérifier que le fichier cible contienne bien des données (tail) --> le fichier contient des données

Vérification de l'horodatage :
Lancer le script puis un date +%s afin de comparer les deux valeurs --> les deux valeurs ne sont différentes que de quelques secondes

Vérification XXYY :
Lancer le script deux fois à 30 secondes d'intervales --> les deux valeurs retournées par le script doivent être différentes et le timestamp doit avoir augmenté de 30

Gestion des erreurs : 
Lancer le script en changeant ses paramètres (à savoir l'ip de dest; le fichier de dest; avec une mauvaise communauté ...) --> doit renvoyer les erreurs apropriées à chaque fausse erreur implantée

Version 3 du script : gestion des erreurs et du premier lancement : 

```
#!/bin/bash

# Définition des variables
oid="IF-MIB::ifHCOutOctets.3"  # OID du compteur d’octets sortants
agent_ip="192.168.1.1"          # Adresse IP de l’équipement SNMP
community="public"              # Communauté SNMP
filename="/var/log/snmp_data.log" # Fichier de stockage des données
max_counter=$((2**64))          # Valeur max du compteur 64 bits

# Récupération de la valeur actuelle du compteur SNMP
current_value=$(snmpget -v2c -Oqv -c "$community" "$agent_ip" "$oid")
current_timestamp=$(date +%s)

# Vérification si la récupération SNMP a fonctionné
if [[ -z "$current_value" || ! "$current_value" =~ ^[0-9]+$ ]]; then
    echo "Erreur : Impossible de récupérer la valeur SNMP."
    exit 1
fi

# Vérification si le fichier existe et contient une mesure précédente
if [[ ! -s "$filename" ]]; then
    # Première exécution : on enregistre sans calcul de débit
    echo "$current_timestamp $current_value" > "$filename"
    echo "Première exécution : données initiales enregistrées."
    exit 0
fi

# Lecture de la dernière mesure stockée
read last_timestamp last_value < <(tail -n 1 "$filename")

# Calcul du temps écoulé
time_diff=$((current_timestamp - last_timestamp))

# Vérification que le temps écoulé est valide
if [[ "$time_diff" -le 0 ]]; then
    echo "Erreur : Problème de synchronisation temporelle."
    exit 1
fi

# Gestion du rebouclage du compteur SNMP (overflow)
if [[ "$current_value" -lt "$last_value" ]]; then
    byte_diff=$(( (max_counter - last_value) + current_value ))
else
    byte_diff=$((current_value - last_value))
fi

# Calcul du débit en bits/s
bit_rate=$(( (byte_diff * 8) / time_diff ))

# Stockage des résultats dans le fichier
echo "$current_timestamp $current_value $bit_rate" >> "$filename"

# Affichage pour le suivi
echo "Mesure enregistrée : Timestamp=$current_timestamp, Octets=$current_value, Débit=${bit_rate}bps"
```

##Question 20 : 

Le problème posé par le bouclage du compteur est l'obtention lors de deux mesures successives de valeurs moins elevées au fil du temps, ce qui n'est pas logique et qui donnerait un débit négatif. Afin de corriger ce problème, on peut intégrer cette "équation" : 
```
diff_mesure = (MAX_COUNTER - valeur_précédente) + valeur_actuelle
```
la valeur MAX_COUNTER représente la valeur maximale que le compteur peut recevoir (2^32 pour le compteur a 32 bits et 2^64 pour celui à 64)
Afin d'obtenir une deuxième valeur précise, on va soustraire à la valeur maximale du compteur la valeur de notre mesure précédente, puis y ajouter la valeur actuelle après bouclage, ce qui nous donnera un résultat exact. 

dans le script ??

```
max_counter=$((2**64))  # Pour un compteur 64 bits
#max_counter=$((2**32)) # pour un compteur 32 bits

if [[ "$current_value" -lt "$last_value" ]]; then
    # Gestion du rebouclage
    byte_diff=$(( (max_counter - last_value) + current_value ))
else
    byte_diff=$((current_value - last_value))
fi
```

EXECUTION VIA CRON :
```
sudo mv snmp-monitor.sh /usr/local/bin/snmp-monitor.sh
sudo chmod +x /usr/local/bin/snmp-monitor.sh  # Rendre exécutable
```
```
crontab -e
```
```
* * * * * /usr/local/bin/snmp-monitor.sh >> /var/log/snmp_monitor.log 2>&1
```

```"* * * * *"``` rend le fichier executable toutes les minutes ;
```"/usr/local/bin/snmp-monitor.sh"``` chemin absolu du script ;
```">> /var/log/snmp_monitor.log"``` sors les resultats dans le fichier de log ;
```"2>&1"``` stocke les erreurs vers le fichier de log ;

```crontab -l``` pour vérifier que le script est bien en execution, on doit avoir notre ligne ajoutée ;

```tail -f /var/log/snmp_monitor.log``` pour vérifier les lignes de log en temps réel ;

