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

Capture du SNMP-GET : avec l'option -x pour avoir sous la forme d'une suite d'octet 
```
[root@G3-813-B etudiant]# tshark -i enp0s8 -f "udp port 161" -x
0000  00 00 5e 00 01 01 08 00 27 06 aa 84 08 00 45 00   ..^.....'.....E.
0010  00 4b b2 de 40 00 40 11 6b fc 0a 64 03 02 0a 64   .K..@.@.k..d...d
0020  03 fe d9 52 00 a1 00 37 1c 10 30 2d 02 01 01 04   ...R...7..0-....
0030  0a 31 32 33 74 65 73 74 31 32 33 a0 1c 02 04 69   .123test123....i
0040  af f7 77 02 01 00 02 01 00 30 0e 30 0c 06 08 2b   ..w......0.0...+
0050  06 01 02 01 01 06 00 05 00                        .........

0000  08 00 27 06 aa 84 08 00 27 da 5f e9 08 00 45 00   ..'.....'._...E.
0010  00 62 00 05 00 00 ff 11 9f be 0a 64 03 fe 0a 64   .b.........d...d
0020  03 02 00 a1 d9 52 00 4e 40 5e 30 44 02 01 01 04   .....R.N@^0D....
0030  0a 31 32 33 74 65 73 74 31 32 33 a2 33 02 04 69   .123test123.3..i
0040  af f7 77 02 01 00 02 01 00 30 25 30 23 06 08 2b   ..w......0%0#..+
0050  06 01 02 01 01 06 00 04 17 44 61 74 61 20 43 65   .........Data Ce
0060  6e 74 65 72 20 2d 20 53 61 6c 6c 65 20 31 32 31   nter - Salle 121
```

```
Capturing on 'enp0s8'
    1 0.000000000   10.100.3.2 → 10.100.3.254 SNMP 89 get-request 1.3.6.1.2.1.1.6.0
    2 0.000905282 10.100.3.254 → 10.100.3.2   SNMP 112 get-response 1.3.6.1.2.1.1.6.0
```
