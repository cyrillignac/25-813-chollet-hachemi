#!/bin/bash

M1=$(snmpget -v2c -c 123test123 -Oqv 10.100.3.254 1.3.6.1.2.1.2.2.1.16.3) # Mesure du nombre d'octets envoyés
sleep 10
M2=$(snmpget -v2c -c 123test123 -Oqv 10.100.3.254 1.3.6.1.2.1.2.2.1.16.3) # Mesure du nombre d'octets envoyés après 10 secondes
echo "Débit sortant: $(( (M2 - M1) * 8 / 10 )) bits/s" # Calcul du débit sortant en bits par seconde
