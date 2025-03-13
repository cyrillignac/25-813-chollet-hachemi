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
date=$(date +%s)

# Affichage du résultat
"echo "Valeur du compteur d’octets de l’interface 3 : ${value}"
echo "${date};${value}" >> "${filename}"
