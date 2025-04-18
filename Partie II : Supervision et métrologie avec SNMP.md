# Partie II : Supervision et métrologie avec SNMP
## 1. Configuration de SNMPv3 dans les routeurs 
Nous allons mettre en place un agent SNMPv2 sur nos deux routeurs. On utilisera une authentification SHA avec comme mot de passe auth_pass pour l'utilisateur snmpuser.    
Pour la confidentialité, l’algorithme utilisé sera aes 128 bits avec comme mot de passe crypt_pass. Les machines A et B seront utilisées comme client SNMP.  
Nous avons mis comme valeur pour sylocation :  Data Center - Salle 121  
Et pour syscontact : Admin <emeline.chollet@etu.univ-smb.fr>  
Nous avons mis en place le protocole SNMPv3 sur nos routeurs.  
Nous pouvons voir ci-dessous les informations de snmp user :  
```bash
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

### Question 8 :
La commande qui nous permet de récupèrer l'objet syslocation est la suivante.
Sur le Client : 
```bash
[etudiant@G3-813-B ~]$ snmpget -v3 -u snmpuser -l authPriv -a SHA -A auth_pass -x AES -X crypt_pass 10.100.3.254 SNMPv2-MIB::sysLocation.0
SNMPv2-MIB::sysLocation.0 = STRING: Data Center - Salle 121
```
### Validation III

## 2. Configuration de SNMPv2 dans les routeurs 
Dans cette partie nous allons mettre en place SNMPv2 dans les routeurs.
Voici ci-dessous la configuration snmp que nous avons mis en place sur les routeurs ainsi que sur les machines internes.
```
813-R2#show running-config | include snmp
snmp-server group SNMPv3Group v3 priv
snmp-server community 123test123 RW
```
Sur le Client : 
```bash
[etudiant@G3-813-B ~]$ snmpget -v2c -c 123test123 10.100.3.254 SNMPv2-MIB::sysLocation.0
SNMPv2-MIB::sysLocation.0 = STRING: Data Center - Salle 121
```
### Question 9 
SNMP est encodé grâce au mécanisme BER(Basic Encoding Rules).

### Question 10 : 
Nous avons faire une capture du SNMP-GET sur la deuxième interface du routeur R2.
Capture du SNMP-GET : avec l'option -x pour avoir sous la forme d'une suite d'octet 
snmpwalk -v 2c -c 123test123 10.250.0.6 1.3.6.1.2.1.2.2.1.4.2  

Voici ci-dessous les trames sous la forme d'une suite d'octet :  
```bash
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
Nous pouvons mettre en forme ces 4 trames de la même manière que vue en cours pour pouvoir comprarer avec les résultats vue en cours.  

| En-tête IP | En-tête UDP | Version | Communauté | PDU | Identificateur de requête | Status d'erreur | Index d'erreur | Nom | Valeur |
|------------|-------------|---------|------------|-----|----------------------------|-----------------|----------------|-----|--------|
| 0a 64 03 02 0a fa 00 06 (Source IP: 10.100.3.2, Destination IP: 10.250.0.6) | a5 d9 00 a1 00 39 18 b0 (Source Port: 42457, Destination Port: 161, Length: 57) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a1 1e (Get-Next Request) | 02 04 50 a2 8e 4c (Request ID: 135792468) | 02 01 00 (Error Status: No Error) | 00 (Error Index: 0) | 0a 2b 06 01 02 01 02 02 01 04 02 (Nombre de chiffre (0a), OID: 1.3.6.1.2.1.2.2.1.4.2) | 05 00 (Value: Null) |
| 0a fa 00 06 0a 64 03 02 (Source IP: 10.250.0.6, Destination IP: 10.100.3.2) | 00 a1 a5 d9 00 3b 55 ca (Source Port: 161, Destination Port: 42457, Length: 59) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a2 20 (Get-Response) | 02 04 50 a2 8e 4c (Request ID: 135792468) | 02 01 00 (Error Status: No Error) | 00 (Error Index: 0) | 0a 2b 06 01 02 01 02 02 01 04 03 (OID: 1.3.6.1.2.1.2.2.1.4.3) | 02 05 dc (Value: 1500) |
| 0a 64 03 02 0a fa 00 06 (Source IP: 10.100.3.2, Destination IP: 10.250.0.6) | a5 d9 00 a1 00 39 18 b0 (Source Port: 42457, Destination Port: 161, Length: 57) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a0 1e (Get-Request) | 02 04 50 a2 8e 4d (Request ID: 135792469) | 02 01 00 (Error Status: No Error) | 00 (Error Index: 0) | 0a 2b 06 01 02 01 02 02 01 04 02 (OID: 1.3.6.1.2.1.2.2.1.4.2) | 05 00 (Value: Null) |
| 0a fa 00 06 0a 64 03 02 (Source IP: 10.250.0.6, Destination IP: 10.100.3.2) | 00 a1 a5 d9 00 3b 55 ca (Source Port: 161, Destination Port: 42457, Length: 59) | 02 01 01 (SNMP Version 2c) | 0a 31 32 33 74 65 73 74 31 32 33 (Community: 123test123) | a2 20 (Get-Response) | 02 04 50 a2 8e 4d (Request ID: 135792469) | 02 01 00 (Error Status: No Error) | 00 (Error Index: 0) | 0a 2b 06 01 02 01 02 02 01 04 02 (OID: 1.3.6.1.2.1.2.2.1.4.2) | 02 05 dc (Value: 1500) |

Nous pouvons voir que la trame correspond bien à la théorie vue en cours.  
```bash
[root@G3-813-B etudiant]# tshark -i enp0s8 -f "udp port 161"
Running as user "root" and group "root". This could be dangerous.
Capturing on 'enp0s8'
    1 0.000000000   10.100.3.2 → 10.250.0.6   SNMP 91 get-next-request 1.3.6.1.2.1.2.2.1.4.2
    2 0.002727542   10.250.0.6 → 10.100.3.2   SNMP 93 get-response 1.3.6.1.2.1.2.2.1.4.3
    3 0.002831012   10.100.3.2 → 10.250.0.6   SNMP 91 get-request 1.3.6.1.2.1.2.2.1.4.2
    4 0.003934426   10.250.0.6 → 10.100.3.2   SNMP 93 get-response 1.3.6.1.2.1.2.2.1.4.2

```

On s’intéresse ici à l’affichage des informations SNMP correspondant au fonctionnement de VRRP.
  
### Question 11 : 
La ligne du fichier de la MIB VRRP qui indique l'OID relatif de la branche VRRP par rapport à mib-2 est :  
```bash
vrrpMIB OBJECT IDENTIFIER ::= { mib-2 68 }
```
### Question 12 : 
La commande ```_snmpwalk -v2c -c 123test123 10.100.3.254 vrrpMIB_ ```échoue car  l'objet vrrpMIB que nous tentons d'interroger via SNMP n'est pas trouvé dans la base de données MIB du périphérique cible (ici 10.100.3.254 : l'interface interne du routeur).

### Question 13 : 
On s'intéresse ici à la table vrrpOperTable.  
Nous pouvons voir ci-dessous la vrrpOperTable de R2 avec les explications des 8 premières lignes.  
```bash
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
### Validation IV  
## 3. Métrologie
On s'intéresse dans cette partie aux possibilités offertes par SNMP pour faire de la métrologie. On se focalisera sur la mesure du débit et notamment sur la précision de cette mesure.  

### Question 14 : 
Après avoir mis en place iperf sur nos deux machines Linux A et B.  
Sur B nous avons lancé la commande ``` iperf3 -s``` en mode serveur.  
Sur A nous avons lancé la commande ``` iperf3 -C 10.100.3.2``` en mode client.  
Nous pouvons voir que Iperf utilise par défaut TCP mais peut être utilisé avec UDP (avec l'option -u). Le temps de test est de 10 secondes par défaut, mais il peut être modifié (avec l'option -t).  

### Question 15 : 
Les différences de mesures trouvées entre l'utilisation de l'outil Iperf et Capinfos peuvent provenir de la manière de traiter la donnée (la prise en compte des entêtes udp ou non), de la manière de capturer les trames et de les traiter (les traiter au fur et à mesure ou après la capture), ou bien encore la prise en compte des retransmissions quand certains paquets échouent.  
  
Voici ci-dessous un Iperf lancé vers la machine B sur la machine A :   
```bash
[root@G3-813-A etudiant]# iperf3 -c 10.100.3.2 -u -b 500K
Connecting to host 10.100.3.2, port 5201
[  5] local 10.100.3.1 port 54508 connected to 10.100.3.2 port 5201
[ ID] Interval           Transfer     Bitrate         Total Datagrams
[  5]   0.00-1.00   sec  62.2 KBytes   510 Kbits/sec  44
[  5]   1.00-2.00   sec  60.8 KBytes   498 Kbits/sec  43
[  5]   2.00-3.00   sec  60.8 KBytes   498 Kbits/sec  43
[  5]   3.00-4.00   sec  60.8 KBytes   498 Kbits/sec  43
[  5]   4.00-5.00   sec  60.8 KBytes   498 Kbits/sec  43
[  5]   5.00-6.00   sec  60.8 KBytes   498 Kbits/sec  43
[  5]   6.00-7.00   sec  62.2 KBytes   510 Kbits/sec  44
[  5]   7.00-8.00   sec  60.8 KBytes   498 Kbits/sec  43
[  5]   8.00-9.00   sec  60.8 KBytes   498 Kbits/sec  43
[  5]   9.00-10.00  sec  60.8 KBytes   498 Kbits/sec  43
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec   611 KBytes   500 Kbits/sec  0.000 ms  0/432 (0%)  sender
[  5]   0.00-10.01  sec   611 KBytes   500 Kbits/sec  0.067 ms  0/432 (0%)  receiver

```

Capture wireshark (capinfos) prise sur l'interface 2 de la machine B (vers le routeur) :  
```bash
[root@G3-813-B etudiant]# capinfos /tmp/capture-500k-udp.pcap
File name:           /tmp/capture-500k-udp.pcap
File type:           Wireshark/... - pcapng
File encapsulation:  Ethernet
File timestamp precision:  nanoseconds (9)
Packet size limit:   file hdr: (not set)
Number of packets:   434
File size:           658kB
Data size:           643kB
Capture duration:    9,993791566 seconds
First packet time:   2025-03-17 14:07:30,714963648
Last packet time:    2025-03-17 14:07:40,708755214
Data byte rate:      64kBps
Data bit rate:       515kbps
Average packet size: 1483,38 bytes
Average packet rate: 43 packets/s
SHA256:              1dbf95fb6d802d55d3b7f6464f2173c1451484a2116498b7d543d8738c9fb018
RIPEMD160:           dd647c69e1ad03d109d4fe233d0af701eef9c378
SHA1:                ea858a76e033a99b67d8981f01cf98c95fb67c6b
Strict time order:   True
Capture hardware:    Intel(R) Xeon(R) Platinum 8458P (with SSE4.2)
Capture oper-sys:    Linux 5.14.0-70.26.1.el9_0.x86_64
Capture application: Dumpcap (Wireshark) 3.4.10 (Git commit 733b3a137c2b)
Number of interfaces in file: 1
Interface #0 info:
                     Name = enp0s8
                     Encapsulation = Ethernet (1 - ether)
                     Capture length = 262144
                     Time precision = nanoseconds (9)
                     Time ticks per second = 1000000000
                     Time resolution = 0x09
                     Filter string = udp port 5201
                     BPF filter length = 0
                     Operating system = Linux 5.14.0-70.26.1.el9_0.x86_64
                     Number of stat entries = 1
                     Number of packets = 434

```
## 

L'objectif de cette partie est de vérifier que les compteurs d'octets associés aux interfaces permettent d'avoir une vision précise du nombre de bits entrant/sortant d'une machine. Ces compteurs d'octets accessibles en SNMP permettront donc de calculer les débits entrant/sortant d'une machine.
  
### Question 16 :

Il est préferable d'utiliser les compteurs d'octets en version 32bits si notre débit sur nos interfaces est inférieur à 10 Mbits/s et si notre équipement ne support pas le SNMPv2c ou SNMPv3.

Il est préférable d'utiliser les compteurs d'octets en version 64bits si notre débit sur nos interfaces est supérieur à 100 Mbits/s. Cela évite les problèmes de dépassement si le polling SNMP dépasse 30 secondes, et garantit une mesure fiable.

Dans notre cas il est préférable d'utiliser les compteurs d'octets en version 32 bits, car nous n'avons pas un débit supérieur à 100 Mbits/s.

ifInOctets et ifOutOctets (32 bits) :
- ifInOctets (OID : .1.3.6.1.2.1.2.2.1.10) : Compteur d'octets entrants (32 bits).
- ifOutOctets (OID : .1.3.6.1.2.1.2.2.1.16) : Compteur d'octets sortants (32 bits).

ifHCInOctets et ifHCOutOctets (64 bits) :
- ifHCInOctets (OID : .1.3.6.1.2.1.31.1.1.1.6) : Compteur d'octets entrants (64 bits, High Capacity).
- ifHCOutOctets (OID : .1.3.6.1.2.1.31.1.1.1.10) : Compteur d'octets sortants (64 bits, High Capacity).

### Question 17 :
Nous allons nous intéresser au débit sortant du réseau. Voici ci-dessous une manipulation simple permmettant de trouver le débit sortant dans notre réseau.

La machine B (ancienne IP : 10.100.3.2) est actuellement sur le VLAN 140 et a pour IP : 192.168.141.35
Sur B, lancer la commande ``` ipfer3 -s ``` pour mettre la machine en mode écoute.     
Sur A, lancer la commande ``` iperf3 -C 192.168.141.35 -t 30 -b 1M ```. Ici l'option ```-t``` permet de générer un flux pendant 30 secondes.  
  
Sur A, lancer le script ci-dessous ("[script_q17_debit_sortant.sh]("https://github.com/cyrillignac/25-813-chollet-hachemi/blob/main/script_q17_debit_sortant.sh")"), qui mesure le débit sortant.  

```bash
M1=$(snmpget -v2c -c 123test123 -Oqv 10.100.3.254 1.3.6.1.2.1.2.2.1.16.3) # Mesure du nombre d'octets envoyés
sleep 10
M2=$(snmpget -v2c -c 123test123 -Oqv 10.100.3.254 1.3.6.1.2.1.2.2.1.16.3) # Mesure du nombre d'octets envoyés après 10 secondes
echo "Débit sortant: $(( (M2 - M1) * 8 / 10 )) bits/s" # Calcul du débit sortant en bits par seconde
```
Le .3 à la fin de l'OID correspond à la l'interface GigabitEthernet3 du routeur (interface externet du routeur, au niveau du réseau 10.250.0.0/24).  

Grâce au script nous obtenons un débit sortant d'environ 1084451 bits/s, soit 1,10 Mbits/s
Avec iperf3, nous avons un débit sortant d'environ 1,03 Mbits/s.  
Nous observons que les valeurs obtenues via la commande snmpget et iperf3 sont similaires.

### Validation V
