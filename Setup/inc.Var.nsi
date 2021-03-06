SetCompressor /SOLID lzma

Var SoftwareName
Var SoftwareCaption
Var ProgrameFolder
Var LinkName
!define VERSIONMAIN 3.7



;Name and file
Name $SoftwareName 
Caption $SoftwareCaption  
!include "nsisversion.nsi"
BrandingText "$SoftwareName (Rev. ${REVERSION})"

AutoCloseWindow true
SetDateSave on
SetDatablockOptimize on
CRCCheck off
SilentInstall normal
;BGGradient 000000 800000 FFFFFF
InstallColors FF8080 000030
XPStyle on

;Default installation folder
InstallDir "$PROGRAMFILES\SPlayer"


InstallDirRegKey HKLM "Software\SPlayer" "Install_Dir"

;!include registry.nsh
;!insertmacro COPY_REGISTRY_KEY

!include ..\Setup\strstr.nsh
!include ..\Setup\pintask.nsh

LicenseData $(license)


;--------------------------------
;Interface Settings

RequestExecutionLevel admin

!ifdef INTERNATIONAL
; Note: Please change "Open Candy Sample" to the name of your product
!define OC_STR_MY_PRODUCT_NAME "Splayer"  
; Note: Please change the key and secret on this line to the ones assigned for your specific products
!define OC_STR_KEY "f473060f1c0a998fdda47d5652b6e2fe"
!define OC_STR_SECRET "539786553ae1e0f7213502c6c6a0ae09"
; Note: Please change the registry path to match your company name
!define OC_STR_REGISTRY_PATH "Software\SPlayer\OpenCandy"
!endif


!include "MUI2.nsh"
!include InstallOptions.nsh 

;!define MUI_HEADERIMAGE
;!define MUI_ABORTWARNING
;!define MUI_HEADERIMAGE_BITMAP "header.bmp"
;!define MUI_WELCOMEFINISHPAGE_BITMAP "left.bmp"
;!define MUI_UNWELCOMEFINISHPAGE_BITMAP "left.bmp"
!define  MUI_ICON "..\src\apps\mplayerc\res\icon.ico"
;!define  MUI_UNICON "SPlayer.ico"




!ifdef OEM_SERIAL_CODE

Page custom SetCustom ValidateCustom "wqed" /ENABLECANCEL

ReserveFile "${NSISDIR}\Plugins\InstallOptions.dll"
ReserveFile "oemjyzj.ini"
Function SetCustom
  !insertmacro MUI_HEADER_TEXT "验证授权" "请输入注册码"
  !insertmacro INSTALLOPTIONS_DISPLAY "oemjyzj.ini"
FunctionEnd

Function ValidateCustom

  !insertmacro INSTALLOPTIONS_READ $R0 "oemjyzj.ini" "Field 2" "State"
   StrCmp $R0 "${OEM_SERIAL_CODE}" +3 0
    MessageBox MB_ICONEXCLAMATION|MB_OK "请输入正确的注册码"
    Abort

FunctionEnd

!else

!insertmacro MUI_PAGE_LICENSE   $(license)
!endif

!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN "$INSTDIR\splayer.exe" 
!define MUI_FINISHPAGE_RUN_TEXT $(RegisterToSystem)
; 168 video  504 audio
!define MUI_FINISHPAGE_RUN_PARAMETERS "/adminoption 168" 

!ifdef OEM_FINISH_ACTION_NAME
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "${OEM_FINISH_ACTION_NAME}"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION ${OEM_FINISH_ACTION_FUNCTION}
!endif

!ifndef OEM_SOFTWARE_NAME
!define MUI_FINISHPAGE_LINK  $(VisitChangeLog)
!define MUI_FINISHPAGE_LINK_LOCATION "http://blog.splayer.org/"
!endif
!insertmacro MUI_PAGE_FINISH



Function WriteToFile
 Exch $0 ;file to write to
 Exch
 Exch $1 ;text to write
 
  FileOpen $0 $0 a #open file
   FileSeek $0 0 END #go to end
   FileWrite $0 $1 #write to file
  FileClose $0
 
 Pop $1
 Pop $0
FunctionEnd
 
!macro WriteToFile String File
 Push "${String}"
 Push "${File}"
  Call WriteToFile
!macroend
!define WriteToFile "!insertmacro WriteToFile"

;!insertmacro MUI_UNPAGE_WELCOME
;!insertmacro MUI_UNPAGE_COMPONENTS

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Pages

;!insertmacro MUI_PAGE_WELCOME


;--------------------------------
;Languages



!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "TradChinese"





VIAddVersionKey   "FileVersion" "${VERSIONMAIN}.0.${REVERSION}"
VIAddVersionKey  "ProductName" "射手影音播放器"
VIAddVersionKey "LegalCopyright" "splayer.org"
VIAddVersionKey FileDescription "射手影音播放器安装文件"


VIProductVersion "${VERSIONMAIN}.0.${REVERSION}"
VIAddVersionKey "InternalName" "SPlayerSetup.exe"

VIAddVersionKey /LANG=${LANG_ENGLISH}  "FileVersion" "${VERSIONMAIN}.0.${REVERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH}  "ProductName" "SPlayer"
VIAddVersionKey /LANG=${LANG_ENGLISH}  "LegalCopyright" "Sagittarius Technology Co. Ltd."
VIAddVersionKey /LANG=${LANG_ENGLISH}  FileDescription "SPlayer Installer"


;--------------------------------
;Installer Sections
/*
;--------------------------------
!macro IfKeyExists ROOT MAIN_KEY KEY
push $R0
push $R1

!define Index 'Line${__LINE__}'

StrCpy $R1 "0"

"${Index}-Loop:"
; Check for Key
EnumRegKey $R0 ${ROOT} "${MAIN_KEY}" "$R1"
StrCmp $R0 "" "${Index}-False"
  IntOp $R1 $R1 + 1
  StrCmp $R0 "${KEY}" "${Index}-True" "${Index}-Loop"

"${Index}-True:"
;Return 1 if found
push "1"
goto "${Index}-End"

"${Index}-False:"
;Return 0 if not found
push "0"
goto "${Index}-End"

"${Index}-End:"
!undef Index
exch 2
pop $R0
pop $R1
!macroend

; Pages

Page components

Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles*/




; The stuff to install
Section  "$SoftwareName" SPlayer

  SectionIn RO
	
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
;  !insertmacro IfKeyExists "HKCU" "SOFTWARE\SPlayer\射手影音播放器" "Recent Dub List"
;  Pop $R0
;  StrCmp $R0 1 skipcopy
;  ${COPY_REGISTRY_KEY} HKCU "SOFTWARE\Gabest\Media Player Classic\Recent Dub List" HKCU "SOFTWARE\SPlayer\射手影音播放器\Recent Dub List"
;  ${COPY_REGISTRY_KEY} HKCU "SOFTWARE\Gabest\Media Player Classic\Recent File List" HKCU "SOFTWARE\SPlayer\射手影音播放器\Recent File List"
;  ${COPY_REGISTRY_KEY} HKCU "SOFTWARE\Gabest\Media Player Classic\Recent Url List" HKCU "SOFTWARE\SPlayer\射手影音播放器\Recent Url List"
;  skipcopy:
	Delete  $INSTDIR\mplayerc.exe
  ; Put file there
!ifdef OEMEXE
  File  /oname=SPlayer.exe ${OEMEXE}
!else
  File "..\out\bin\SPlayer.exe"
!endif

  File ".\thirdparty\PmpSplitter.ax"
  File ".\thirdparty\rlapedec.ax"

  File ".\thirdparty\haalis.ax"
  File ".\thirdparty\ts.dll"
  File ".\thirdparty\mkunicode.dll"
  File ".\thirdparty\mkzlib.dll"
  File "..\ThirdParty\sinet\trunk\Release\sinet.dll"
  File "..\ThirdParty\pkg\trunk\unrar\unrar.dll"
  File "..\ThirdParty\pkg\trunk\sphash\Release\sphash.dll"
  File ".\thirdparty\ogm.dll"
  File ".\thirdparty\mp4.dll"
  ;File "..\..\cook.dll"
  ;File "..\..\pncrt.dll"
  ;File "..\..\atrc.dll"
  File ".\thirdparty\ir41_32.ax"
  File ".\thirdparty\ir50_32.dll"
  File ".\thirdparty\vp6dec.ax"
  ;File ".\thirdparty\sipr.dll"
  ;File "..\..\rtsp.ax"
  File ".\thirdparty\mmamrdmx.ax"
  File ".\thirdparty\RadGtSplitter.ax"
  File ".\thirdparty\binkw32.dll"
  File ".\thirdparty\smackw32.dll"
;	File "..\..\wmadmod.dll"  
;	File "..\..\wmasf.dll"  
;	File "..\..\wmvcore.dll"  
  File ".\thirdparty\vp8decoder.dll"  


;	RegDLL $INSTDIR\wmadmod.dll
;RegDLL $INSTDIR\wvc1dmod.dll

	!include "inc.uninstallV.nsi"
	
	SetOutPath $INSTDIR\lang
  File ".\lang\splayer.fr.dll"
  File ".\lang\splayer.en.dll"
  File ".\lang\splayer.ru.dll"
  File ".\lang\splayer.ge.dll"
  File ".\lang\splayer.cht.dll"
  
  SetOutPath $INSTDIR\hotkey
  File ".\thirdparty\SPlayer.key"
	SetOutPath $INSTDIR
	
	!ifdef OEMSKIN
		CreateDirectory $INSTDIR\skins
		SetOutPath  $INSTDIR\skins
		File /r ${OEMSKIN}\*.*
		SetOutPath $INSTDIR
	!endif
	!ifdef OEMWATERMARK 
	
		CreateDirectory $INSTDIR\skins
  	File /oname=$INSTDIR\skins\WATERMARK2.png ${OEMWATERMARK}
  	SetOutPath $INSTDIR
  !endif
  !ifdef OEMLOGO 
  	CreateDirectory $INSTDIR\skins
  	File  /oname=$INSTDIR\skins\oembg.png ${OEMLOGO}
  	SetOutPath $INSTDIR
  !endif
  
  ExecShell open `cmd.exe` `/c CACLS "$INSTDIR" /e /c /T /P Users:F` SW_HIDE
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SPlayer" "DisplayName" "$SoftwareName"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SPlayer" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SPlayer" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SPlayer" "NoRepair" 1
  
  ;RegDLL $INSTDIR\ogm.dll
  ;RegDLL $INSTDIR\mp4.dll
  ;RegDLL $INSTDIR\ts.dll
  ;RegDLL $INSTDIR\haalis.ax
  RegDLL $INSTDIR\ir41_32.ax
  RegDLL $INSTDIR\ir50_32.dll
 
  DeleteRegKey HKCR "Media Type\Extensions\.csf"
  DeleteRegKey HKCR "Software\Microsoft\MediaPlayer\Player\Extensions\.csf"
  DeleteRegKey HKLM "Software\Microsoft\MediaPlayer\Player\Extensions\.csf"
  DeleteRegKey HKCR "Media Type\Extensions\.mkv"
  DeleteRegKey HKCR "Media Type\Extensions\.mks"
  DeleteRegKey HKCR "Media Type\Extensions\.mka"
	DeleteRegKey HKCR "Media Type\{E436EB83-524F-11CE-9F53-0020AF0BA770}\{49952F4C-3EDC-4A9B-8906-1DE02A3D4BC2}"
  
  DeleteRegKey  HKLM "SYSTEM\CurrentControlSet\Control\MediaResources\msacm\msacm.lameacm"
	DeleteRegValue	HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\drivers.desc" "LameACM.acm" 
	DeleteRegValue	HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\drivers32" "msacm.lameacm" 
  
  !ifdef OEMTITLE 
  	WriteRegStr HKLM "Software\SPlayer" "OEM" "${OEMTITLE}"
  !endif
  !ifdef OEMSTORELINK 
  	WriteRegStr HKLM "Software\SPlayer" "OEMSTORELINK" "${OEMSTORELINK}"
  !endif
  !ifdef OEM_SOFTWARE_NAME 
  	WriteRegStr HKLM "Software\SPlayer" "OEMFULLNAME" "${OEM_SOFTWARE_NAME}"
  !endif
  !ifdef OEMSUB 
  	WriteRegStr HKLM "Software\SPlayer" "OEMSUB" ${OEMSUB}
  !endif
  ;WriteRegDWORD HKCU "SOFTWARE\SPlayer\射手影音播放器\Settings" "USEGPUAcel" 0x00000000
	WriteRegStr HKCU "SOFTWARE\GNU\ffdshow" "isWhitelist" 0x00000000
	WriteRegStr HKCU "SOFTWARE\GNU\ffdshow\default" "autoq" 0x00000001
  WriteRegStr HKLM "SOFTWARE\SPlayer" "Install_Dir" "$INSTDIR"
  WriteUninstaller "uninstall.exe"
  
  SetShellVarContext current
  Delete /REBOOTOK "$QUICKLAUNCH\$LinkName.lnk"
  Delete /REBOOTOK "$DESKTOP\$LinkName.lnk"
  
  SetShellVarContext all
  
!ifndef OEMSTARTPARM
  CreateShortCut "$DESKTOP\$LinkName.lnk" "$INSTDIR\SPlayer.exe"
  CreateShortCut "$QUICKLAUNCH\$LinkName.lnk" "$INSTDIR\SPlayer.exe"
!else
  CreateShortCut "$DESKTOP\$LinkName.lnk" "$INSTDIR\SPlayer.exe" "${OEMSTARTPARM}"
  CreateShortCut "$QUICKLAUNCH\$LinkName.lnk" "$INSTDIR\SPlayer.exe" "${OEMSTARTPARM}"
!endif  
  StrCpy $0 '"$INSTDIR\SPlayer.exe"'
  call PinToTaskbar
  
  StrCpy $0 '"$QUICKLAUNCH\User Pinned\TaskBar\Windows Media Player.lnk"'
  call UnpinFromTaskbar
  
  StrCmp $LANGUAGE 1033 eng 
	StrCmp $LANGUAGE 2052 chn 
	StrCmp $LANGUAGE 1028 tchn 
	Goto eng
chn:
 
	${WriteToFile} "0" "$INSTDIR\lang\default"
  Goto done
tchn:
	${WriteToFile} "0" "$INSTDIR\lang\default"
	 Goto done
eng:

  ${WriteToFile} "1" "$INSTDIR\lang\default"
  ;WriteRegDWORD HKCU "SOFTWARE\SPlayer\射手影音播放器\Settings" "AutoDownloadSVPSub" 0x00000000
  Goto done

done:
   SetRebootFlag false
SectionEnd

!ifndef OEM_WITHOUT_THEATER
	Section /o "影院模式"  HTPCMode
    SetShellVarContext current
    Delete /REBOOTOK  "$SMPROGRAMS\$ProgrameFolder\$LinkName($(TheaterMode)).lnk"
    Delete /REBOOTOK  "$QUICKLAUNCH\$LinkName($(TheaterMode)).lnk" 
    
    SetShellVarContext all
		CreateShortCut "$SMPROGRAMS\$ProgrameFolder\$LinkName($(TheaterMode)).lnk" "$INSTDIR\SPlayer.exe" "/htpc" "$INSTDIR\SPlayer.exe" 0
		CreateShortCut "$QUICKLAUNCH\$LinkName($(TheaterMode)).lnk" "$INSTDIR\SPlayer.exe" "/htpc"
		CreateShortCut "$DESKTOP\$LinkName($(TheaterMode)).lnk" "$INSTDIR\SPlayer.exe" "/htpc"
  
		SetRebootFlag false
  SectionEnd
!endif

Section /o "重置"  ResetSettingSec
	DeleteRegKey HKCU "SOFTWARE\SPlayer"
	Delete $INSTDIR\settings.db
	RMDir /r $APPDATA\SPlayer
	SetRebootFlag false
SectionEnd


SectionGroup "其他" OtherSec
Section "程序和开始菜单项" ProgramMenuSec
  SetShellVarContext current
  RMDir /REBOOTOK  "$SMPROGRAMS\$ProgrameFolder"
  
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\$ProgrameFolder"
  CreateShortCut "$SMPROGRAMS\$ProgrameFolder\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\$ProgrameFolder\$LinkName.lnk" "$INSTDIR\SPlayer.exe" "" "$INSTDIR\SPlayer.exe" 0


;	IfFileExists $INSTDIR\codecs\Real\settings.exe 0 +2
; 		CreateShortCut "$SMPROGRAMS\$ProgrameFolder\设置Real Media.lnk" "$INSTDIR\codecs\Real\settings.exe" "" "$INSTDIR\codecs\Real\real.ico" 0
	
;	IfFileExists  $INSTDIR\codecs\powerdvd\CL264dec.ax 0 +2
;		CreateShortCut "$SMPROGRAMS\射手影音播放器\设置CL264.lnk" "rundll32.exe" '"$INSTDIR\codecs\powerdvd\CL264dec.ax",Configure' "$INSTDIR\codecs\powerdvd\CL264dec.ax" 0
	SetRebootFlag false
SectionEnd



;--------------------------------
SectionGroupEnd

!ifndef litepack
SectionGroup  "影音解码包" ExtraCodecSec
Section  "IVM"  ivmcodec
	SetOutPath $INSTDIR
	File ".\thirdparty\ivm.dll"  
	File ".\thirdparty\mc.dll"  
	File ".\thirdparty\IVMSource.ax"  

SectionEnd


Section  "CSF"  csfcodec
 
  SetOutPath $INSTDIR\csfcodec
	File ".\csfcodec\mpc_mdssockc.dll"
	File ".\csfcodec\mpc_mxscreen.dll"
	File ".\csfcodec\mpc_mxshbasu.dll"
	File ".\csfcodec\mpc_mxshmaiu.dll"
	File ".\csfcodec\mpc_mxshsour.dll"
	File ".\csfcodec\mpc_wtlvcl.dll"
	File ".\csfcodec\mpc_mcucltu.dll"
	File ".\csfcodec\mpc_mcufilecu.dll"
	File ".\csfcodec\mpc_mtcontrol.dll"
	File ".\csfcodec\mpc_mtcontain.dll"
	File ".\csfcodec\mpc_mxsource.dll"
	File ".\csfcodec\mpc_mxrender.dll"
	File ".\csfcodec\mpc_mxvideo.dll"
	File ".\csfcodec\mpc_mxaudio.dll"
	File ".\csfcodec\ijl15.dll"

  ;RegDLL $INSTDIR\csfcodec\mpc_mdssockc.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mxscreen.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mxshbasu.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mxshmaiu.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mxshsour.dll
	;RegDLL $INSTDIR\csfcodec\mpc_wtlvcl.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mcucltu.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mcufilecu.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mtcontrol.dll
	;UnRegDLL $INSTDIR\csfcodec\mpc_mtcontain.dll
	;UnRegDLL $INSTDIR\csfcodec\mpc_mxsource.dll
	;UnRegDLL $INSTDIR\csfcodec\mpc_mxrender.dll
	;UnRegDLL $INSTDIR\csfcodec\mpc_mxvideo.dll
	;RegDLL $INSTDIR\csfcodec\mpc_mxaudio.dll
	
  SetRebootFlag false
SectionEnd
Section  "CSM"  csmcodec
	 SetOutPath $INSTDIR
	 File .\thirdparty\CSMX.dll
	 File .\thirdparty\Esdll.dll
	 ;File ..\..\csmx.inf
	 ;Exec 'rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 $INSTDIR\csmx.inf'
	
		WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\MediaResources\icm\VIDC.CSM0" "Description" "CSMfyuv lossless codec [CSM0]"
		WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\MediaResources\icm\VIDC.CSM0" "Driver" "CSMX.dll" ;
		WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\MediaResources\icm\VIDC.CSM0" "FriendlyName" "CSMfyuv lossless codec [CSM0]"
		WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" "VIDC.CSM0" "CSMX.dll" ;
  SetRebootFlag false
SectionEnd

Section  "Divx H.264解码"  coreavc
    SetOutPath $INSTDIR
    File ".\thirdparty\dh264.ax"
  
    ;File ..\..\SPlayer.bin\coreavc\cavc.ax
    ;File ..\..\SPlayer.bin\coreavc\coreavc.ico
  
    ;RegDLL $INSTDIR\codecs\cavc.ax
    ;WriteRegDWORD HKCU "Software\GNU\ffdshow" "h264" 0x00000000
SectionEnd


/*
Section  "RealMedia"  realdec
   SetOutPath $INSTDIR
   File ".\thirdparty\drvc.dll"
   File ".\thirdparty\pncrt.dll"
SectionEnd

Section  "GPU硬件显卡加速解码"  powerdvd
    SetOutPath $INSTDIR\codecs\powerdvd
    File ..\..\SPlayer.bin\powerdvd\*.*
   
    RegDLL $INSTDIR\codecs\powerdvd\CL264dec.ax
    WriteRegDWORD HKCU "Software\Cyberlink\Common\cl264dec\mplayerc" "UIUseHVA"  0x00000001
    WriteRegDWORD HKCU "Software\Cyberlink\Common\cl264dec\SPlayer" "UIUseHVA"  0x00000001
    WriteRegDWORD HKCU "Software\Cyberlink\Common\CLVSD" "UIUseHVA"  0x00000001
    ;WriteRegDWORD HKCU "Software\GNU\ffdshow" "h264" 0x00000000
SectionEnd

;*/
;--------------------------------
SectionGroupEnd

!endif


!ifdef BIND360
Section "360安全套装" bind360sec
  SetOutPath $INSTDIR
  File "360Inst-sheshou.exe"
  Exec $INSTDIR\360Inst-sheshou.exe
SectionEnd
!endif
	
Function .onInstSuccess
!ifndef OEMTITLE 
IfSilent +2
 ExecShell open "http://www.splayer.org/install.html"
!endif


!ifdef OEM_INSTALLED_LINK
IfSilent +2
 ExecShell open "${OEM_INSTALLED_LINK}"
!endif


!ifndef OEMTITLE 
!ifdef INTERNATIONAL
; ****** OpenCandy START ******

; ****** OpenCandy END ******
!endif
!endif


!ifdef OEM_DESKTOP_LINK
  SetShellVarContext current
  Delete /REBOOTOK  "$DESKTOP\${OEM_DESKTOP_NAME}.lnk"
  SetShellVarContext all
  CreateShortCut "$DESKTOP\${OEM_DESKTOP_NAME}.lnk" "${OEM_DESKTOP_LINK}" "" "${OEM_DESKTOP_LINK_ICON}" ${OEM_DESKTOP_LINK_ICON_ID}
  SetRebootFlag false
!endif  

  SectionGetFlags ${coreavc} $0
  
  IntOp $0 $0 & ${SF_SELECTED}

	IntCmp $0 ${SF_SELECTED} havecavc cavcnone cavcnone
	havecavc: 
	
	Goto cavcdone
	
	cavcnone:
	RMDir  /r /REBOOTOK $INSTDIR\codecs
	
	cavcdone: 	
	SetRebootFlag false 
FunctionEnd

!ifndef OEMTITLE 


;--------------------------------
; OnGUIEnd
Function .onGUIEnd
!ifdef INTERNATIONAL
; ****** OpenCandy START ******

; ****** OpenCandy END ******
!endif
FunctionEnd
!endif

Function un.onUninstSuccess
!ifndef OEMTITLE 
 ExecShell open "http://www.splayer.org/uninstall.html"
!endif
FunctionEnd


Function  un.onInit


  StrCpy $0 '"$INSTDIR\SPlayer.exe"'
  call un.UnpinFromTaskbar
  
System::Call 'kernel32::GetSystemDefaultLangID(i v)i .R7'
IntOp $R7 $R7 & 0xFFFF

Push "射手影音"
Pop $SoftwareName

Push "射手影音播放器"
Pop $ProgrameFolder

!ifdef OEM_SHORTCUT 
	Push "${OEM_SHORTCUT}"
	Pop $LinkName
!else
	Push "射手影音"
	Pop $LinkName
!endif

IntCmp $R7 0x1004 chn 
IntCmp $R7 0x1404 tchn
IntCmp $R7 0x0c04 tchn 
IntCmp $R7 0x0404 tchn 
IntCmp $R7 0x0804 chn 
Goto Eng
chn:

 Push 2052
 Pop $LANGUAGE 
	
	Push "$SoftwareName 安装程序"
	Pop $SoftwareCaption

  Goto done
tchn:
	Push 1028
 	Pop $LANGUAGE 
 	Push "$SoftwareName 安裝程式"
	Pop $SoftwareCaption
	 Goto done
eng:
 Push 1033
 Pop $LANGUAGE 
 
 Push "SPlayer"
 Pop $SoftwareName
 
 Push "Setup $SoftwareName"
	Pop $SoftwareCaption

	Push "SPlayer"
	Pop $ProgrameFolder
	
	Push "SPlayer"
	Pop $LinkName

  Goto done

done:


FunctionEnd



# [OpenCandy]
	; Have the compiler perform some basic OpenCandy API implementation checks

# [/OpenCandy]