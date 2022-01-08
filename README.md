# AIS_SDR
Decodage de l'AIS via un Dongle SDR

Il y a quelques années, j'ai suivi cet article excelent https://1plus1blog.com/2017/04/19/fabriquer-un-recepteur-ais-avec-antenne-rtl-sdr-et-opencpn/ pour installer l'AIS sur l'ordinateur d'un ami pour sa traversée de la manche (Brest-Plymouth) sur un voilier de 10.5 m

Mon ami n'étant pas féru d'informatique, j'ai transformé AISdeco2.exe en service Windows (pour ne pas riquer de fermer accidentellement la réception de l'AIS pendant la navigation).

J'ai choisi de mettre le service en démarrage manuel afin de ne le lancer que lorsque le Dongle RTL-SDR est branché. J'ai donc créé une petie interface graphique pour gérer le démarage ou l'arret du service.

A la suite de la réinstallation de l'AIS sur un nouvel ordinateur de mon ami, j'ai décidé de mettre à disposition mon travail, si ça peut rendre service à d'autres marins ....

Vous trouverez dans ce repository, la procédure d'installation d'un ensemble complet de reception de l'AIS, ainsi que le code source et le binaire de gestion du service.

Un prérequis à l'utilisation de AISdeco2 est l'installation du package Microsoft Visual C++ 2012 (x86), sans ce package AISdeco2 povoque l'erreur : "impossible de démarrer le programme car il manque MSVCP110.dll sur votre ordinateur"

