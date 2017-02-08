## *** Examples of exe install***
Execute-Process -Path '<application>.exe' -Parameters '/quiet' -WindowStyle Hidden
Execute-Process -Path "$dirFiles\DirectX\DXSetup.exe" -Parameters '/silent' -WindowStyle 'Hidden'
Execute-Process -Path 'uninstall_flash_player.exe' -Parameters '/uninstall' -WindowStyle Hidden

## ** Execute an .exe, and hide confidential parameters from log file **
$serialisation_params = '-batchmode -quit -serial <aa-bb-cc-dd-ee-ffff11111> -username "<serialisation username>" -password "SuperSecret123"'
Execute-Process -Path "$envProgramFiles\Application\Serialise.exe" -Parameters "$serialisation_params" -SecureParameters:$True

##***Example to install an msi***
Execute-MSI -Action 'Install' -Path '$dirFiles\<application>.msi'
Execute-MSI -Action 'Install' -Path 'Discovery 2015.1.msi'

## Install the base MSI and apply a transform
Execute-MSI -Action 'Install' -Path 'Adobe_Reader_11.0.0_EN.msi' -Transform 'Adobe_Reader_11.0.0_EN_01.mst'

## Install a patch
Execute-MSI -Action 'Patch' -Path 'Adobe_Reader_11.0.3_EN.msp'

## To uninstall an MSI
Execute-MSI -Action Uninstall -Path '{5708517C-59A3-45C6-9727-6C06C8595AFD}'

## Uninstall a number of msi codes, careful that the last item does not have a comma
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{2E873893-A883-4C06-8308-7B491D58F3D6}", <# Example #>`
"{B234DC00-1003-47E7-8111-230AA9E6BF10}" <# Last example cannot have a comma after the double quotes #>`
| % { Execute-MSI -Action 'Uninstall' -Path "$_" } <# foreach item, uninstall #>


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
Remove-File -Path '$envCommonDesktop\GeoGraphix Seismic Modeling.lnk'

## Remove a bunch of specific files


## Remove a bunch of specific folders


## Remove a bunch of specific folders, only if they're empty
# If you re-use this snippit, you'll need to put the folders into the below list
# in the "deepest folder level" to "most shallow folder level" order
# for eg, order it c:\program files\vendor\app\v12\junk, then c:\program files\vendor\app\v12, then c:\program files\vendor\app, then c:\program files\vendor
# using the above example, it will only remove c:\program files\vendor if every other folder above is completely empty. if for example v11 was also installed, it would stop prior
( 
    "$envSystemDrive\12d",
    "$envProgramFiles\12d\12dmodel",
    "$envProgramFiles\12d",
    "$envProgramFilesX86\12d\Nodes",
    "$envProgramFilesX86\12d"
) | % { if (!(Test-Path -Path "$_\*")) { Remove-Folder -Path "$_" } }
    # for each fed item, if NOT (the folder specified has contents (*)), remove the folder 

## Import a certificate to system 'Trusted Publishers' store.. helpful for clickOnce installers (for references sake, I saved as base64, unsure if DER encoded certs work)
Execute-Process -Path "certutil.exe" -Parameters "-f -addstore -enterprise TrustedPublisher `"$dirFiles\certname.cer`""
Write-Log -Message "Imported Cert" -Source $deployAppScriptFriendlyName	

##***To Create a shortcut***
New-Shortcut -Path "$envCommonPrograms\My Shortcut.lnk" `
    -TargetPath "$envWinDir\system32\notepad.exe" `
    -Arguments "--example-argument --example-argument-two" `
    -Description 'Notepad' `
    -WorkingDirectory "$envHomeDrive\$envHomePath"


##Create Active Setup to Update User Settings
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

##function to assist finding uninstall strings, msi codes, display names of installed applications
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

## Commonly used PSADT env variables
$envCommonDesktop   # C:\Users\Public\Desktop
$envCommonPrograms  # C:\ProgramData\Microsoft\Windows\Start Menu\Programs
$envProgramFiles    # C:\Program Files
$envProgramFilesX86 # C:\Program Files (x86)
$envProgramData     # c:\ProgramData
$envUserDesktop     # c:\Users\{user currently logged in}\Desktop

