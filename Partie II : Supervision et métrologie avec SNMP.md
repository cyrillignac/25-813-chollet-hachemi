# Configuration de SNMPv3 dans les routeurs 

```
813-R2(config)#do show snmp user

User name: snmpuser
Engine ID: 800000090300080027A4BDE9
storage-type: nonvolatile        active
Authentication Protocol: SHA
Privacy Protocol: AES128
Group-name: SNMPv3Group

813-R2(config)#do show snmp group
groupname: ILMI                             security model:v1
contextname: <no context specified>         storage-type: permanent
readview : *ilmi                            writeview: *ilmi
notifyview: <no notifyview specified>
row status: active

groupname: ILMI                             security model:v2c
contextname: <no context specified>         storage-type: permanent
readview : *ilmi                            writeview: *ilmi
notifyview: <no notifyview specified>
row status: active

groupname: SNMPv3Group                      security model:v3 priv
contextname: <no context specified>         storage-type: nonvolatile
readview : v1default                        writeview: <no writeview specified>
notifyview: *tv.FFFFFFFF.FFFFFFFF.FFFFFFFF.F
row status: active
```

## Question 8 :
La commande qui nous permet de récupèrer l'objet syslocation est la suivante.
Sur le Client : 
```
[etudiant@G3-813-B ~]$ snmpget -v3 -u snmpuser -l authPriv -a SHA -A auth_pass -x AES -X crypt_pass 10.100.3.254 SNMPv2-MIB::sysLocation.0
SNMPv2-MIB::sysLocation.0 = STRING: Data Center - Salle 121
```


# Configuration de SNMPv2 dans les routeurs 
```
813-R2#show running-config | include snmp
snmp-server group SNMPv3Group v3 priv
snmp-server community 123test123 RW
```
Sur le Client : 
```
[etudiant@G3-813-B ~]$ snmpget -v2c -c 123test123 10.100.3.254 SNMPv2-MIB::sysLocation.0
SNMPv2-MIB::sysLocation.0 = STRING: Data Center - Salle 121
```
## Question 9 
SNMP est encoder grâce au mécanisme BER(Basic Encoding Rules).

## Question 10 : 
Capture du SNMP-GET : avec l'option -x pour avoir sous la forme d'une suite d'octet 
snmpwalk -v 2c -c 123test123 10.250.0.6 1.3.6.1.2.1.2.2.1.4.2

```
[root@G3-813-B etudiant]# tshark -i enp0s8 -f "udp port 161" -x
Running as user "root" and group "root". This could be dangerous.
Capturing on 'enp0s8'
0000  00 00 5e 00 01 01 08 00 27 06 aa 84 08 00 45 00   ..^.....'.....E.
0010  00 4d 86 26 40 00 40 11 9c 14 0a 64 03 02 0a fa   .M.&@.@....d....
0020  00 06 a5 d9 00 a1 00 39 18 b0 30 2f 02 01 01 04   .......9..0/....
0030  0a 31 32 33 74 65 73 74 31 32 33 a1 1e 02 04 50   .123test123....P
0040  a2 8e 4c 02 01 00 02 01 00 30 10 30 0e 06 0a 2b   ..L......0.0...+
0050  06 01 02 01 02 02 01 04 02 05 00                  ...........

0000  08 00 27 06 aa 84 08 00 27 da 5f e9 08 00 45 00   ..'.....'._...E.
0010  00 4f 00 17 00 00 ff 11 a3 21 0a fa 00 06 0a 64   .O.......!.....d
0020  03 02 00 a1 a5 d9 00 3b 55 ca 30 31 02 01 01 04   .......;U.01....
0030  0a 31 32 33 74 65 73 74 31 32 33 a2 20 02 04 50   .123test123. ..P
0040  a2 8e 4c 02 01 00 02 01 00 30 12 30 10 06 0a 2b   ..L......0.0...+
0050  06 01 02 01 02 02 01 04 03 02 02 05 dc            .............

0000  00 00 5e 00 01 01 08 00 27 06 aa 84 08 00 45 00   ..^.....'.....E.
0010  00 4d 86 2d 40 00 40 11 9c 0d 0a 64 03 02 0a fa   .M.-@.@....d....
0020  00 06 a5 d9 00 a1 00 39 18 b0 30 2f 02 01 01 04   .......9..0/....
0030  0a 31 32 33 74 65 73 74 31 32 33 a0 1e 02 04 50   .123test123....P
0040  a2 8e 4d 02 01 00 02 01 00 30 10 30 0e 06 0a 2b   ..M......0.0...+
0050  06 01 02 01 02 02 01 04 02 05 00                  ...........

0000  08 00 27 06 aa 84 08 00 27 da 5f e9 08 00 45 00   ..'.....'._...E.
0010  00 4f 00 18 00 00 ff 11 a3 20 0a fa 00 06 0a 64   .O....... .....d
0020  03 02 00 a1 a5 d9 00 3b 55 ca 30 31 02 01 01 04   .......;U.01....
0030  0a 31 32 33 74 65 73 74 31 32 33 a2 20 02 04 50   .123test123. ..P
0040  a2 8e 4d 02 01 00 02 01 00 30 12 30 10 06 0a 2b   ..M......0.0...+
0050  06 01 02 01 02 02 01 04 02 02 02 05 dc            .............


```

| En-tête IP | En-tête UDP | Version | Communauté | PDU | Identificateur de requête | Status d'erreur | Index d'erreur | Nom | Valeur |
|------------|-------------|---------|------------|-----|----------------------------|-----------------|----------------|-----|--------|
| 0a 64 03 02 0a fa 00 06 (Source IP: 10.100.3.2, Destination IP: 10.250.0.6) | a5 d9 00 a1 00 39 18 b0 (Source Port: 42457, Destination Port: 161, Length: 57) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a1 1e (Get-Next Request) | 02 04 50 a2 8e 4c (Request ID: 135792468) | 02 01 00 (Error Status: No Error) | 02 01 00 (Error Index: 0) | 30 10 30 0e 06 0a 2b 06 01 02 01 02 02 01 04 02 (OID: 1.3.6.1.2.1.2.2.1.4.2) | 05 00 (Value: Null) |
| 0a fa 00 06 0a 64 03 02 (Source IP: 10.250.0.6, Destination IP: 10.100.3.2) | 00 a1 a5 d9 00 3b 55 ca (Source Port: 161, Destination Port: 42457, Length: 59) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a2 20 (Get-Response) | 02 04 50 a2 8e 4c (Request ID: 135792468) | 02 01 00 (Error Status: No Error) | 02 01 00 (Error Index: 0) | 30 12 30 10 06 0a 2b 06 01 02 01 02 02 01 04 03 (OID: 1.3.6.1.2.1.2.2.1.4.3) | 02 05 dc (Value: 1500) |
| 0a 64 03 02 0a fa 00 06 (Source IP: 10.100.3.2, Destination IP: 10.250.0.6) | a5 d9 00 a1 00 39 18 b0 (Source Port: 42457, Destination Port: 161, Length: 57) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a0 1e (Get-Request) | 02 04 50 a2 8e 4d (Request ID: 135792469) | 02 01 00 (Error Status: No Error) | 02 01 00 (Error Index: 0) | 30 10 30 0e 06 0a 2b 06 01 02 01 02 02 01 04 02 (OID: 1.3.6.1.2.1.2.2.1.4.2) | 05 00 (Value: Null) |
| 0a fa 00 06 0a 64 03 02 (Source IP: 10.250.0.6, Destination IP: 10.100.3.2) | 00 a1 a5 d9 00 3b 55 ca (Source Port: 161, Destination Port: 42457, Length: 59) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a2 20 (Get-Response) | 02 04 50 a2 8e 4d (Request ID: 135792469) | 02 01 00 (Error Status: No Error) | 02 01 00 (Error Index: 0) | 30 12 30 10 06 0a 2b 06 01 02 01 02 02 01 04 02 (OID: 1.3.6.1.2.1.2.2.1.4.2) | 02 05 dc (Value: 1500) |

Nous pouvons voir que la trame correspond bien à théorie vue en cours.
```
[root@G3-813-B etudiant]# tshark -i enp0s8 -f "udp port 161"
Running as user "root" and group "root". This could be dangerous.
Capturing on 'enp0s8'
    1 0.000000000   10.100.3.2 → 10.250.0.6   SNMP 91 get-next-request 1.3.6.1.2.1.2.2.1.4.2
    2 0.002727542   10.250.0.6 → 10.100.3.2   SNMP 93 get-response 1.3.6.1.2.1.2.2.1.4.3
    3 0.002831012   10.100.3.2 → 10.250.0.6   SNMP 91 get-request 1.3.6.1.2.1.2.2.1.4.2
    4 0.003934426   10.250.0.6 → 10.100.3.2   SNMP 93 get-response 1.3.6.1.2.1.2.2.1.4.2

```

## Question 11 : 
La ligne du fichier de la MIB VRRP qui indique l'OID relatif de la branche VRRP par rapport à mib-2 est :
```
vrrpMIB OBJECT IDENTIFIER ::= { mib-2 68 }
```
## Question 12 : 
La commande _snmpwalk -v2c -c 123test123 10.100.3.254 vrrpMIB_ échoue car  l'objet vrrpMIB que nous tentons d'interroger via SNMP n'est pas trouvé dans la base de données MIB du périphérique cible (ici 10.100.3.254 : l'interface interne du routeur).

## Question 13 : 
```
[root@G3-813-B etudiant]# snmpwalk -v2c -c 123test123 10.100.3.251 1.3.6.1.2.1.68.1.3
SNMPv2-SMI::mib-2.68.1.3.1.2.2.1 = Hex-STRING: 00 00 5E 00 01 01   ---> @Mac virtuelle de la table vvrpOperTable
SNMPv2-SMI::mib-2.68.1.3.1.3.2.1 = INTEGER: 3     ---> l'état actuelle du routeur : 3 = Master 
SNMPv2-SMI::mib-2.68.1.3.1.4.2.1 = INTEGER: 1     ---> l'état administratif : 1 = up 
SNMPv2-SMI::mib-2.68.1.3.1.5.2.1 = INTEGER: 100   ---> la priorité dans le processus d'éléction du maître ici 100
SNMPv2-SMI::mib-2.68.1.3.1.6.2.1 = INTEGER: 1     ---> le nombre d'@ip associé au routeur ici 1 
SNMPv2-SMI::mib-2.68.1.3.1.7.2.1 = IpAddress: 10.100.3.251  ---> l'@ip du maître actuel du routeur 
SNMPv2-SMI::mib-2.68.1.3.1.8.2.1 = IpAddress: 10.100.3.254  ---> l'@ip principal associé au routeur  
SNMPv2-SMI::mib-2.68.1.3.1.9.2.1 = INTEGER: 1     ---> le mode préemption du routeur ici : 1 = activé 
SNMPv2-SMI::mib-2.68.1.3.1.10.2.1 = ""
SNMPv2-SMI::mib-2.68.1.3.1.11.2.1 = INTEGER: 1
SNMPv2-SMI::mib-2.68.1.3.1.12.2.1 = INTEGER: 1
SNMPv2-SMI::mib-2.68.1.3.1.13.2.1 = Timeticks: (0) 0:00:00.00
SNMPv2-SMI::mib-2.68.1.3.1.14.2.1 = INTEGER: 1
SNMPv2-SMI::mib-2.68.1.3.1.15.2.1 = INTEGER: 1
```
# Métrologie

## Question 14 : 
Iperf utilise par défaut TCP mais peut être utilisé avec UDP. Pour ce qui est du temps de test, il est de 10 secondes, mais peut aussi être modifié.

## Question 15 : 
Les différences de mesures trouvées entre l'utilisation de l'outil Iperf et Capinfos peuvent provenir de la manière de traiter la donnée (la prise en compte des entêtes tcp ou non), de la manière de capturer les trames et de les traiter (les traiter au fur et à mesure ou après la capture), ou bien encore la prise en compte des retransmissions quand certains paquets échouent. 

## Question 16 :
ifInOctets et ifOutOctets (32 bits) :
- ifInOctets (OID : .1.3.6.1.2.1.2.2.1.10) : Compteur d'octets entrants (32 bits).
- ifOutOctets (OID : .1.3.6.1.2.1.2.2.1.16) : Compteur d'octets sortants (32 bits).

ifHCInOctets et ifHCOutOctets (64 bits) :
- ifHCInOctets (OID : .1.3.6.1.2.1.31.1.1.1.6) : Compteur d'octets entrants (64 bits, High Capacity).
- ifHCOutOctets (OID : .1.3.6.1.2.1.31.1.1.1.10) : Compteur d'octets sortants (64 bits, High Capacity).
