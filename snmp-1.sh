#!/bin/bash

# Définition des paramètres SNMP en dur
oid="IF-MIB::ifHCOutOctets.3"  # OID pour ifInOctets de l'interface 3
agent_ip="10.100.3.254"         # Adresse IP de l'agent SNMP
community="123test123"             # Communauté SNMP v2c


# Exécution de la requête SNMP
value=$(snmpget -v2c -c "$community" "$agent_ip" "$oid" | awk '{print $NF}')


# Récupération de la date en timestamp UNIX
date=$(date +%s)


# Affichage du résultat
echo "Valeur du compteur d’octets de l’interface 3 : ${value}

