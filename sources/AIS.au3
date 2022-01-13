#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=AIS.ico
#AutoIt3Wrapper_Outfile=AIS.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Fileversion=1.0.1.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Fred pour Pyrrhos
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ---------------------------------------------------------------------------------

	Autoit Version:	3.3.14.2
	Author:			Fred Eric

	Script Function
	gestion de l'AIS via SDR

#ce ---------------------------------------------------------------------------------

Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)


#include <ButtonConstants.au3>
#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <Services.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Dim $EtatDongle
Dim $MessageDongle
Dim $AISDeco2
Dim $EtatAISDeco2
Dim $Srvany
Dim $EtatSrvany
Dim $EtatSvcAIS
Dim $SvcAISdeco

_Dongle_SDR()
_Service_AIS()

FileInstall(".\green play button.ico", @TempDir & "\green_play_button.ico", 1)
FileInstall(".\red stop buttun.ico", @TempDir & "\red_stop_buttun.ico", 1)
FileInstall(".\ico_ais.jpg", @TempDir & "\ico_ais.jpg", 1)

;**************** Fenêtre du programme
Dim $AIS_GUI = GUICreate("Gestion du service AIS Décodeur", 688, 438, 417, 173)
GUISetOnEvent($GUI_EVENT_CLOSE, "AIS_GUIClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "AIS_GUIMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "AIS_GUIMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "AIS_GUIRestore")

;**************** Bouton Start
Dim $Button_Start = GUICtrlCreateButton("START", 128, 256, 161, 161, $BS_ICON)
GUICtrlSetImage($Button_Start, @TempDir & "\green_play_button.ico")
GUICtrlSetState($Button_Start, $GUI_DISABLE)
GUICtrlSetOnEvent($Button_Start, "Button_StartClick")

;*************** Bouton Stop
Dim $Button_Stop = GUICtrlCreateButton("STOP", 352, 256, 161, 161, $BS_ICON)
GUICtrlSetImage($Button_Stop, @TempDir & "\red_stop_buttun.ico")
GUICtrlSetState($Button_Stop, $GUI_DISABLE)
GUICtrlSetOnEvent($Button_Stop, "Button_StopClick")

;************** Image latérale
Dim $AIS_Picture = GUICtrlCreatePic(@TempDir & "\ico_ais.jpg", 0, 40, 209, 201)

;*************** Groupe Service AIS & SDR
Dim $Group_Etat = GUICtrlCreateGroup("Etat du service : AIS Décodeur et du SDR", 216, 32, 433, 209)
GUICtrlSetFont($Group_Etat, 12, 400, 0, "MS Sans Serif")

;*************** Etat du SDR
Dim $SDR_Etat = GUICtrlCreateLabel("SDR_Etat", 248, 64, 250, 32, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetData($SDR_Etat, $MessageDongle)
GUICtrlSetFont($SDR_Etat, 12, 800, 0, "MS Sans Serif")
If $EtatDongle Then
	GUICtrlSetColor($SDR_Etat, $COLOR_GREEN)
	GUICtrlSetState($Button_Start, $GUI_ENABLE)
Else
	GUICtrlSetColor($SDR_Etat, $COLOR_RED)
	GUICtrlSetState($Button_Start, $GUI_DISABLE)
EndIf
GUICtrlSetBkColor($SDR_Etat, 0xFFFFFF)

;*************** Bouton Rescan SDR
Dim $Button_Scan = GUICtrlCreateButton("Rescan", 512, 64, 81, 33)
GUICtrlSetOnEvent($Button_Scan, "Button_ScanClick")

;************** Groupe Service AIS
Dim $Group_Service = GUICtrlCreateGroup("Etat du service : AIS Décodeur", 232, 112, 401, 120)

;************** Etat Service AISdeco
Dim $AISdecoSvcEtat = GUICtrlCreateLabel("AISdecoder_Service_Etat", 248, 128, 345, 32, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetData($AISdecoSvcEtat, $SvcAISdeco)
GUICtrlSetFont($AISdecoSvcEtat, 12, 800, 0, "MS Sans Serif")
If $EtatSvcAIS Then
	GUICtrlSetColor($AISdecoSvcEtat, $COLOR_GREEN)
	GUICtrlSetState($Button_Stop, $GUI_ENABLE)
Else
	GUICtrlSetColor($AISdecoSvcEtat, $COLOR_RED)
	GUICtrlSetState($Button_Stop, $GUI_DISABLE)
EndIf
GUICtrlSetBkColor($AISdecoSvcEtat, 0xFFFFFF)

;************** Etat AISdeco2
Dim $AISdeco_Srv_Etat = GUICtrlCreateLabel("AISdecoder_Service_Etat", 248, 161, 345, 32, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetData($AISdeco_Srv_Etat, $AISDeco2)
GUICtrlSetFont($AISdeco_Srv_Etat, 12, 800, 0, "MS Sans Serif")
If $EtatAISDeco2 Then
	GUICtrlSetColor($AISdeco_Srv_Etat, $COLOR_GREEN)
Else
	GUICtrlSetColor($AISdeco_Srv_Etat, $COLOR_RED)
EndIf
GUICtrlSetBkColor($AISdeco_Srv_Etat, 0xFFFFFF)

;************** Etat Srvany
Dim $Srvany_Svc_Etat = GUICtrlCreateLabel("AISdecoder_Service_Etat", 248, 194, 345, 32, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetData($Srvany_Svc_Etat, $Srvany)
GUICtrlSetFont($Srvany_Svc_Etat, 12, 800, 0, "MS Sans Serif")
If $EtatSrvany Then
	GUICtrlSetColor($Srvany_Svc_Etat, $COLOR_GREEN)
Else
	GUICtrlSetColor($Srvany_Svc_Etat, $COLOR_RED)
EndIf
GUICtrlSetBkColor($Srvany_Svc_Etat, 0xFFFFFF)

;************** Fin du Groupe Service AIS
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($Group_Service, $GUI_DISABLE)

;************** Fin du Groupe Service AIS & SDR
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($Group_Etat, $GUI_DISABLE)

Dim $Button_Quit = GUICtrlCreateButton("Quitter", 560, 384, 89, 33)
GUICtrlSetOnEvent($Button_Quit, "AIS_GUIClose")

;************* Affichage de la fenêtre
GUISetState(@SW_SHOW)

Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE

Func AIS_GUIClose()
	GUIDelete()
	Exit
EndFunc   ;==>AIS_GUIClose
Func AIS_GUIMaximize()

EndFunc   ;==>AIS_GUIMaximize
Func AIS_GUIMinimize()

EndFunc   ;==>AIS_GUIMinimize
Func AIS_GUIRestore()

EndFunc   ;==>AIS_GUIRestore
Func Button_ScanClick()
	_Dongle_SDR()
	GUICtrlSetData($SDR_Etat, $MessageDongle)
	If $EtatDongle Then
		GUICtrlSetColor($SDR_Etat, $COLOR_GREEN)
		GUICtrlSetState($Button_Start, $GUI_ENABLE)
	Else
		GUICtrlSetColor($SDR_Etat, $COLOR_RED)
		GUICtrlSetState($Button_Start, $GUI_DISABLE)
	EndIf
EndFunc   ;==>Button_ScanClick
Func Button_StartClick()
	_Start_AIS()
	_Service_AIS()
	Sleep(1500)
	_MAJ_AIS()
EndFunc   ;==>Button_StartClick
Func Button_StopClick()
	_Stop_AIS()
	_Service_AIS()
	Sleep(1500)
	_MAJ_AIS()
EndFunc   ;==>Button_StopClick

; **************  Etat du Dongle *******************
Func _Dongle_SDR()
	$EtatDongle = False
	$MessageDongle = "Tuner SDR absent !"
	Dim $Obj_WMIService = ObjGet('winmgmts:\root\cimv2') ;
	Dim $col_Items = $Obj_WMIService.ExecQuery("SELECT * FROM Win32_PnPEntity WHERE DeviceID LIKE 'USB\\VID_0BDA&PID_2838&MI_00\\%'")
	If $col_Items.Count = 1 Then
		$EtatDongle = True
		$MessageDongle = "Tuner SDR OK"
	EndIf
EndFunc   ;==>_Dongle_SDR

; **************  Etat du Service *******************
Func _Service_AIS()
	$EtatSrvany = False
	$EtatAISDeco2 = False
	$Srvany = "Process Srvany.exe : KO!"
	$AISDeco2 = "Process AISdeco2.exe : KO!"
	If ProcessExists("aisdeco2.exe") Then
		$AISDeco2 = "AISdeco2 est : OK"
		$EtatAISDeco2 = True
	EndIf
	If ProcessExists('srvany.exe') Then
		$Srvany = "Srvany est : OK"
		$EtatSrvany = True
	EndIf

	$SvcAISdeco = "Service AIS Décodeur : stopé !"
	Dim $Obj_WMIService = ObjGet('winmgmts:\root\cimv2')
	Dim $col_Items = $Obj_WMIService.ExecQuery("SELECT * FROM Win32_Service WHERE Name = 'AISDecoder'")
	For $objItem In $col_Items
		$EtatSvcAIS = $objItem.Started
	Next
	If $EtatSvcAIS Then
		$SvcAISdeco = "Service AIS Décodeur : démarré"
	EndIf
EndFunc   ;==>_Service_AIS

;**************  Gestion du service ***************
Func _Start_AIS()
	Dim $iReturn = RunWait(@ComSpec & " /c " & 'net start AISDecoder', "", @SW_HIDE)
EndFunc   ;==>_Start_AIS


Func _Stop_AIS()
	Dim $iReturn = RunWait(@ComSpec & " /c " & 'net stop AISDecoder', "", @SW_HIDE)
EndFunc   ;==>_Stop_AIS

Func _MAJ_AIS()

	;************** MAJ Service AISdeco
	GUICtrlSetData($AISdecoSvcEtat, $SvcAISdeco)
	If $EtatSvcAIS Then
		GUICtrlSetColor($AISdecoSvcEtat, $COLOR_GREEN)
		GUICtrlSetState($Button_Stop, $GUI_ENABLE)
	Else
		GUICtrlSetColor($AISdecoSvcEtat, $COLOR_RED)
		GUICtrlSetState($Button_Stop, $GUI_DISABLE)
	EndIf

	;************** MAJ AISdeco2
	GUICtrlSetData($AISdeco_Srv_Etat, $AISDeco2)
	If $EtatAISDeco2 Then
		GUICtrlSetColor($AISdeco_Srv_Etat, $COLOR_GREEN)
	Else
		GUICtrlSetColor($AISdeco_Srv_Etat, $COLOR_RED)
	EndIf

	;************** Etat Srvany
	GUICtrlSetData($Srvany_Svc_Etat, $Srvany)
	If $EtatSrvany Then
		GUICtrlSetColor($Srvany_Svc_Etat, $COLOR_GREEN)
	Else
		GUICtrlSetColor($Srvany_Svc_Etat, $COLOR_RED)
	EndIf
EndFunc   ;==>_MAJ_AIS

