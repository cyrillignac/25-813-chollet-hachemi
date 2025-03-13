#!/bin/bash

# Définition des paramètres SNMP en dur
oid="IF-MIB::ifHCOutOctets.3"  # OID pour ifInOctets de l'interface 3
agent_ip="10.100.3.254"         # Adresse IP de l'agent SNMP
community="123test123"             # Communauté SNMP v2c
filename="throughput_int1.txt" # Fichier de stockage des données

# Exécution de la requête SNMP
#value=$(snmpget -v2c -c "$community" "$agent_ip" "$oid" | awk '{print $NF}')
value=$(snmpget -v2c -Oq -c ${community} ${agent_ip} ${oid} | cut -d " " -f 2)

# Récupération de la date en timestamp UNIX
#date=$(date +%s)
current_time=$(date +%s)

# Affichage du résultat
#"echo "Valeur du compteur d’octets de l’interface 3 : ${value}"
#echo "${date};${value}" >> "${filename}"

# Lecture de la dernière ligne du fichier
last_line=$(tail -n 1 "$filename" 2>/dev/null)

# Vérification si le fichier contient déjà des données
if [[ -n "$last_line" ]]; then
    # Extraction de l'ancien timestamp et valeur
    last_time=$(echo "$last_line" | cut -d ";" -f 1)
    last_value=$(echo "$last_line" | cut -d ";" -f 2)

    # Calcul du débit en bit/s
    time_diff=$((current_time - last_time))
    value_diff=$((value - last_value))
    
    if [[ $time_diff -gt 0 ]]; then
        throughput=$(( (value_diff * 8) / time_diff ))  # Octets → Bits
    else
        throughput=0
    fi
else
    throughput=0
fi

# Écriture des nouvelles données dans le fichier
echo "${current_time};${value};${throughput}" >> "${filename}"
