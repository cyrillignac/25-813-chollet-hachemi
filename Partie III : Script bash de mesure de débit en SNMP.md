Durant cette partie nous allons devoir développer un script Bash qui permet de mesurer les débits des flux entrant ou sortant d’un équipement. 
Par exemple, notre script doit permettre de connaître le débit sortant d'une interface d'un routeur, avec un relevé effectué toutes les minutes sur une très longue période.
Les mesures de débit sont stokées dans un fichier.

On fixe comme prériodicité minimale de la mesure 1 minutes et comme périodicité maximale 30 mintutes.
Nous allons écrire un script sur la machine linux.

## Question 18 : 
La fonction sleep est un processus qui reste en cours d'exécution en arrière-plan. Si le processus est tué ou si le système redémarre, le script ne redémarrera pas automatiquement, contrairement à cron ou systemd
Le processus sleep reste actif même si il n'est pas utilisé, cela consomme de la mémoire et du CPU. Contrairement au job cron ou un timer systemd, ne lance le script que lorsqu'il est nécessaire.

Nous allons donc utilisé cron ou les timers systemd dans notre à la place du processus sleep

