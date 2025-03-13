#!/bin/bash

# Définition des paramètres SNMP en dur
oid="1.3.6.1.2.1.2.2.1.10.3"  # OID pour ifInOctets de l'interface 3
agent_ip="10.100.3.254"         # Adresse IP de l'agent SNMP
community="public"             # Communauté SNMP v2c

# Exécution de la requête SNMP
value=$(snmpget -v2c -c "$community" "$agent_ip" "$oid" | awk '{print $NF}')

# Affichage du résultat
echo "Valeur du compteur d’octets de l’interface 3 : ${value}"
