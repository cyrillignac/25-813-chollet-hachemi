#!/bin/bash

# Définition des paramètres SNMP
oid="IF-MIB::ifHCOutOctets.3"  # OID pour ifHCOutOctets de l'interface 3
agent_ip="10.100.3.254"         # Adresse IP de l'agent SNMP
community="123test123"          # Communauté SNMP v2c
filename="throughput_int1.txt"  # Fichier de stockage des données

# Exécution de la requête SNMP et récupération de la valeur
value=$(snmpget -v2c -Oqv -c "$community" "$agent_ip" "$oid" 2>/dev/null)

# Vérification de la récupération SNMP
if [[ -z "$value" || ! "$value" =~ ^[0-9]+$ ]]; then
    echo "Erreur : Impossible de récupérer la valeur SNMP depuis $agent_ip." >&2
    exit 1
fi

# Récupération de la date en timestamp UNIX
current_time=$(date +%s)

# Vérification si le fichier existe et contient des données
if [[ ! -s "$filename" ]]; then
    # Première exécution : enregistrement des données sans calcul de débit
    echo "${current_time};${value};FIRST_RUN" > "$filename"
    echo "Première exécution : données enregistrées. Le débit sera calculé lors de la prochaine exécution."
    exit 0
fi

# Lecture de la dernière ligne du fichier
last_line=$(tail -n 1 "$filename")

# Extraction de l'ancien timestamp et valeur
last_time=$(echo "$last_line" | cut -d ";" -f 1)
last_value=$(echo "$last_line" | cut -d ";" -f 2)

# Vérification si c'était la première exécution
if [[ "$last_value" == "FIRST_RUN" ]]; then
    last_time=$current_time
    last_value=$value
    echo "${current_time};${value};0" > "$filename"
    echo "Deuxième exécution : première mesure complète enregistrée, calcul de débit activé à partir de maintenant."
    exit 0
fi

# Calcul du débit en bits/s
time_diff=$((current_time - last_time))
value_diff=$((value - last_value))

if [[ $time_diff -gt 0 ]]; then
    throughput=$(( (value_diff * 8) / time_diff ))  # Conversion octets → bits
else
    throughput=0
fi

# Écriture des nouvelles données dans le fichier
echo "${current_time};${value};${throughput}" >> "$filename"

# Affichage du résultat pour suivi
echo "Mesure enregistrée : Timestamp=$current_time, Octets=$value, Débit=${throughput}bps"
