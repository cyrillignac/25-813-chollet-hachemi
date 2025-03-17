#!/bin/bash

# Définition des variables en dur (pour l'instant)
oid="IF-MIB::ifHCOutOctets.3"  # OID du compteur d’octets sortants pour l’interface 3
agent_ip="A DEFINIR"          # Adresse IP de l’équipement SNMP (exemple)
community="public"              # Communauté SNMP

# Exécution de la requête SNMP et récupération de la valeur brute
value=$(snmpget -v2c -c "$community" -Oqv "$agent_ip" "$oid")

# Affichage du résultat
echo "$value"
