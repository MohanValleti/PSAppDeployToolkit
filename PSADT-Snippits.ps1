## *** Examples of exe install***

Execute-Process -Path '<application>.exe' -Parameters '/quiet' -WindowStyle Hidden
Execute-Process -Path "$dirFiles\DirectX\DXSetup.exe" -Parameters '/silent' -WindowStyle 'Hidden'
Execute-Process -Path 'uninstall_flash_player.exe' -Parameters '/uninstall' -WindowStyle Hidden

##***Example to install an msi***

Execute-MSI -Action 'Install' -Path '$dirFiles\<application>.msi'
Execute-MSI -Action 'Install' -Path 'Discovery 2015.1.msi'

## Install the base MSI and apply a transform

Execute-MSI -Action 'Install' -Path 'Adobe_Reader_11.0.0_EN.msi' -Transform 'Adobe_Reader_11.0.0_EN_01.mst'

## Install a patch
Execute-MSI -Action 'Patch' -Path 'Adobe_Reader_11.0.3_EN.msp'

## To uninstall an MSI
Execute-MSI -Action Uninstall -Path '{5708517C-59A3-45C6-9727-6C06C8595AFD}'

## ***Run a vbscript***
Execute-Process -Path "cscript.exe" -Parameters "$dirFiles\whatever.vbs"

##***Remove registry key***
Remove-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Macromedia\FlashPlayer\SafeVersions' -Recurse -ContinueOnError:$True

## ***Create a reg key***
Set-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\LMKR\Licensing' -Name 'LMKR_LICENSE_FILE' -Value '@license'-Type String -ContinueOnError:$True

## ***To set an HKCU key for all users including default profile***

[scriptblock]$HKCURegistrySettings = {
    Set-RegistryKey -Key 'HKEY_CURRENT_USER\SOFTWARE\Classes\AppX4hxtad77fbk3jkkeerkrm0ze94wjf3s9' -Name 'NoOpenWith' -Value '""'-Type String -ContinueOnError:$True
}
Invoke-HKCURegistrySettingsForAllUsers -RegistrySettings $HKCURegistrySettings

## To sleep

Start-Sleep -Seconds 120

## ***To copy and overwrite a file***

Copy-File -Path "$dirSupportFiles\mms.cfg" -Destination "C:\Windows\SysWOW64\Macromed\Flash\mms.cfg"

## ***To copy a file***

Copy-File -Path "$dirSupportFiles\mms.cfg" -Destination "C:\Windows\SysWOW64\Macromed\Flash\"

## ***To copy a folder***

Copy-Item -Path "$dirFiles\client_1" -Destination "C:\oracle\product\11.2.0\client_1" -Recurse

## ***To delete a file or shortcut***

#remove c:\Users\public\desktop\GeoGraphix Seismic Modeling.lnk
Remove-File -Path '$envCommonDesktop\GeoGraphix Seismic Modeling.lnk'

## Import a certificate to system 'Trusted Publishers' store.. helpful for clickOnce installers (for references sake, I saved as base64, unsure if DER encoded certs work)

Execute-Process -Path "certutil.exe" -Parameters "-f -addstore -enterprise TrustedPublisher `"$dirFiles\certname.cer`""
Write-Log -Message "Imported Cert" -Source $deployAppScriptFriendlyName	

##***To Create a shortcut***

New-Shortcut -Path "$envProgramData\Microsoft\Windows\Start Menu\My Shortcut.lnk" `
    -TargetPath "$envWinDir\system32\notepad.exe" `
    -IconLocation "$envWinDir\system32\notepad.exe" `
    -Description 'Notepad' `
    -WorkingDirectory "$envHomeDrive\$envHomePath"


#Create Active Setup to Update User Settings

#1
Copy-File -Path "$dirFiles\Example.exe" -Destination "$envProgramData\Example"
Set-ActiveSetup -StubExePath "$envProgramData\Example\Example.exe" `
    -Description 'AutoDesk BIM Glue install' `
    -Key 'Autodesk_BIM_Glue_Install' `
    -ContinueOnError:$true

#2
Copy-File -Path "$dirSupportFiles\LyncUserSettings.cmd" -Destination "$envWindir\Installer\LyncUserSettings.cmd"
    Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "" -Value "{90150000-012B-0409-0000-0000000FF1CE}" -Type String
    Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "ComponentID" -Value "{90150000-012B-0409-0000-0000000FF1CE}" -Type String
    Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "Version" -Value "15,0,4420,1017" -Type String
    Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "StubPath" -Value "$envWindir\Installer\LyncUserSettings.cmd" -Type String
    Set-RegistryKey -Key "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{90150000-012B-0409-0000-0000000FF1CE}" -Name "Locale" -Value "EN" -Type String

#for reference, Contents of "LyncUserSettings.cmd" above ^^ 

REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v TwoLineView /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v ShowPhoto /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v ShowFavoriteContacts /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v MinimizeWindowToNotificationArea /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v AutoOpenMainWindowWhenStartup /t REG_DWORD /d 0 /f

#function to assist finding uninstall strings, msi codes, display names of installed applications
#usage: 'Get-Uninstaller chrome'
function Get-Uninstaller {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Name
  )
 
  $local_key     = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
  $machine_key32 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
  $machine_key64 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
 
  $keys = @($local_key, $machine_key32, $machine_key64)
 
  Get-ItemProperty -Path $keys -ErrorAction 'SilentlyContinue' | ?{ ($_.DisplayName -like "*$Name*") -or ($_.PsChildName -like "*$Name*") } | Select-Object PsPath,DisplayVersion,DisplayName,UninstallString,InstallSource,QuietUninstallString
}