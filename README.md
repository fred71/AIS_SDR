# AIS_SDR


## Decodage de l'AIS via un Dongle RTL-SDR


## Historique

Il y a quelques années, j'ai suivi cet [excellent article](https://1plus1blog.com/2017/04/19/fabriquer-un-recepteur-ais-avec-antenne-rtl-sdr-et-opencpn/) pour installer l'AIS sur l'ordinateur d'un ami pour sa traversée de la Manche (Brest-Plymouth) sur un voilier de 10.5 m

Mon ami n'étant pas féru d'informatique, j'ai transformé AISdeco2.exe en service Windows (pour ne pas risquer de fermer accidentellement la réception de l'AIS pendant la navigation).

J'ai choisi de mettre le service en démarrage manuel afin de ne le lancer que lorsque le Dongle RTL-SDR est branché. J'ai donc créé (avec AutoIt) une petite interface graphique pour gérer le démarrage ou l'arrêt du service.

À la suite de la réinstallation de l'AIS sur un nouvel ordinateur, j'ai décidé de mettre à disposition mon travail, si ça peut rendre service à d'autres marins ...

Vous trouverez dans ce repository : le code source et le binaire de gestion du service de réception de l'AIS et ci-dessous, la procédure d'installation.

## Prérequis

* Un dongle RTL-SDR
* Le drivers Zadig (https://zadig.akeo.ie/downloads/)
* La librairie libusb-1.0.dll (https://libusb.info/)
* La librairie rtlsdr.dll (http://osmocom.org/attachments/download/2242/RelWithDebInfo.zip)
* l'executable AISdeco2.exe (http://xdeco.org/ le site ne semble plus exister, j'ai donc ajouté ce binaire à mes sources dans `xdeco.org`)
* l'executable srvany.exe (Ressource Kit Tools Microsoft 2003) on ne le trouve plus sur le site officiel de Microsoft, en revanche on peut encore le trouver là (https://www.technlg.net/windows/download-windows-resource-kit-tools/)
* l'executable AIS.exe (dans les binaires de ce repository)

Un prérequis à l'utilisation de AISdeco2 est l'installation du package [Microsoft Redistribuable Visual C++ 2012 (x86)](https://www.microsoft.com/fr-FR/download/details.aspx?id=30679), sans ce package AISdeco2 povoque l'erreur : "impossible de démarrer le programme car il manque MSVCP110.dll sur votre ordinateur"

## Installation

   1) Suivre l'article mentionné plus haut pour l'installation et le calibrage de votre Dongle RTL-SDR. (https://1plus1blog.com/2017/04/19/fabriquer-un-recepteur-ais-avec-antenne-rtl-sdr-et-opencpn/)

   2) Copier srvany.exe dans %SystemRoot%\system32\

   3) Copier AIS.exe, aisdeco2.exe, libusb-1.0.dll et rtlsdr.dll dans %ProgramFiles(x86)%\aisdeco\

   4) Executer dans une fenêtre de commande dos lancée en tant qu'administrateur : 
> sc create AISDecoder binPath= %SystemRoot%\system32\srvany.exe DisplayName= "Déodeur AIS"

   5) Créer puis fusionner au registre un fichier nommé aisdecosrvany.reg, contenant :
   
>   Windows Registry Editor Version 5.00
>
>[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\AISDecoder]
>"Description"="Décode les informations AIS en provenance d'un dongle rtl_sdr pour OpenCPN"
>
>[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\AISDecoder\Parameters]
>"Application"="%ProgramFiles(x86)%\\aisdeco\\aisdeco2.exe"
>"AppParameters"="--gain 43.9 --freq-correction 5 --freq 161975000 --freq 162025000 --net 30007 --udp 127.0.0.1:4159"

Adapter les valeurs `--gain` et `--freq-correction` avec les valeurs que vous avez obtenues en suivant l'article de calibrage de votre Dongle RTL-SDR

   6) Créer un raccourci sur le bureau pour AIS.exe

## Bonus

Vous trouverez dans les binaires de ce repository, un installeur créé avec Inno Setup qui fera tout ça pour vous, il ne vous restera plus alors qu'à créer un fichier aisdecosrvany.reg, contenant :

>   Windows Registry Editor Version 5.00
>
>[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\AISDecoder\Parameters]
>"AppParameters"="--gain 43.9 --freq-correction 5 --freq 161975000 --freq 162025000 --net 30007 --udp 127.0.0.1:4159"

Pour renseigner vos valeurs personnalisées de `--gain` et `--freq-correction`, puis de le fusionner à votre registre.
