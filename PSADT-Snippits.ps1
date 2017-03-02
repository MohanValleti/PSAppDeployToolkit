## Commonly used PSADT env variables
$envCommonDesktop           # C:\Users\Public\Desktop
$envCommonPrograms          # C:\ProgramData\Microsoft\Windows\Start Menu\Programs
$envProgramFiles            # C:\Program Files
$envProgramFilesX86         # C:\Program Files (x86)
$envProgramData             # c:\ProgramData
$envUserDesktop             # c:\Users\{user currently logged in}\Desktop
$envUserStartMenuPrograms   # c:\Users\{user currently logged in}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
$envSystemDrive             # c:
$envWinDir                  # c:\windows

## How to load ("dotsource") PSADT functions/variables for manual testing (your powershell window must be run as administrator first)
cd "$path_to_PSADT_folder_youre_working_from"
. .\AppDeployToolkit\AppDeployToolkitMain.ps1

## *** Examples of exe install***
Execute-Process -Path '<application>.exe' -Parameters '/quiet' -WindowStyle 'Hidden'
Execute-Process -Path "$dirFiles\DirectX\DXSetup.exe" -Parameters '/silent' -WindowStyle 'Hidden'
#open notepad, don't wait for it to close before proceeding (i.e. continue with script)
Execute-Process -Path "$envSystemRoot\notepad.exe" -NoWait 
#Execute an .exe, and hide confidential parameters from log file
$serialisation_params = '-batchmode -quit -serial <aa-bb-cc-dd-ee-ffff11111> -username "<serialisation username>" -password "SuperSecret123"'
Execute-Process -Path "$envProgramFiles\Application\Serialise.exe" -Parameters "$serialisation_params" -SecureParameters:$True

##***Example to install an msi***
Execute-MSI -Action 'Install' -Path '$dirFiles\<application>.msi'
Execute-MSI -Action 'Install' -Path 'Discovery 2015.1.msi'
#MSI install + transform file
Execute-MSI -Action 'Install' -Path 'Adobe_Reader_11.0.0_EN.msi' -Transform 'Adobe_Reader_11.0.0_EN_01.mst'

## Install a patch
Execute-MSI -Action 'Patch' -Path 'Adobe_Reader_11.0.3_EN.msp'

## To uninstall an MSI
Execute-MSI -Action Uninstall -Path '{5708517C-59A3-45C6-9727-6C06C8595AFD}'

## Uninstall a number of msi codes
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

#import a .reg key, useful if there's a butt-tonne of nested keys/etc
Execute-Process -FilePath "reg.exe" -Parameters "IMPORT `"$dirFiles\name-of-reg-export.reg`"" -PassThru

## To pause script for <x> time
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
"$envCommonDesktop\Example 1.lnk", <# Example #>`
"$envCommonDesktop\Example 2.lnk", <# Example #>`
"$envCommonDesktop\Example 3.lnk" <# Careful with the last item to not include a comma after the double quote #>`
| % { Remove-File -Path "$_" }

## Remove a bunch of specific folders and their contents
"$envSystemDrive\Example Dir1",  <# Example #>`
"$envProgramFiles\Example Dir2",  <# Example #>`
"$envProgramFiles\Example Dir3",  <# Example #>`
"$envProgramFilesX86\Example Dir4",  <# Example #>`
"$envSystemRoot\Example4" <# Careful with the last item to not include a comma after the double quote #>``
| % { Remove-Folder -Path "$_" }

## Remove a bunch of specific folders, only if they're empty
<# Use this by specifying folders from "deepest folder level" to "most shallow folder level" order e.g.
c:\program files\vendor\app\v12\junk - then 
c:\program files\vendor\app\v12 - then
c:\program files\vendor\app - then
c:\program files\vendor

using the above example, it will only remove c:\program files\vendor if every other folder above is completely empty. 
if for example v11 was also installed, it would stop prior #>
(
    "$envProgramFiles\vendor\app\v12\junk",
    "$envProgramFiles\vendor\app\v12",
    "$envProgramFiles\vendor\app",
    "$envProgramFiles\vendor",
    "$envProgramFilesX86\vendor\app\v12\junk",
    "$envProgramFilesX86\vendor\app\v12",
    "$envProgramFilesX86\vendor\app",
    "$envProgramFilesX86\vendor" <# careful not to include the comma after the double quotes in this one #>
) | % { if (!(Test-Path -Path "$_\*")) { Remove-Folder -Path "$_" } }
    # for each piped item, if the folder specified DOES NOT have contents ($folder\*), remove the folder 

## Import a certificate to system 'Trusted Publishers' store.. helpful for clickOnce installers & importing drivers
# (for references sake, I saved as base64, unsure if DER encoded certs work)
Execute-Process -Path "certutil.exe" -Parameters "-f -addstore -enterprise TrustedPublisher `"$dirFiles\certname.cer`""
Write-Log -Message "Imported Cert" -Source $deployAppScriptFriendlyName

## Import a driver (note, >= win7 must be signed, and cert must be in trusted publishers store) 
Execute-Process -Path 'PnPutil.exe' -Parameters "/a $dirFiles\USB Drivers\driver.inf"

## Register a DLL module
Execute-Process -FilePath "regsvr32.exe" -Parameters "/s `"$dirFiles\example\codec.dll`""





## While loop pause (incase app installer exits immediately)
#pause until example reg key
While(!(test-path -path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{product-code-hereD}")) {
                sleep 5;
                Write-Log -Message "$appVendor - $appName - $appVersion is still not finished installing, sleeping another 5" -Source $deployAppScriptFriendlyName;
}
#pause until example file
While(!(test-path -path "$envCommonDesktop\Example Shortcut.lnk")) {
                sleep 5;
                Write-Log -Message "$appVendor - $appName - $appVersion is still not finished installing, sleeping another 5" -Source $deployAppScriptFriendlyName;
}

##***To Create a shortcut***
New-Shortcut -Path "$envCommonPrograms\My Shortcut.lnk" `
    -TargetPath "$envWinDir\system32\notepad.exe" `
    -Arguments "--example-argument --example-argument-two" `
    -Description 'Notepad' `
    -WorkingDirectory "$envHomeDrive\$envHomePath"

## Modify ACL on a file
#first load the ACL
$acl_to_modify = "$envProgramData\Example\File.txt"
$acl = Get-Acl "$acl_to_modify"
#add another entry to the ACL list (in this case, add all users to have full control)
$ar = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "FullControl", "None", "None", "Allow")
$acl.SetAccessRule($ar)
#re-write the acl on the target file
Set-Acl "$acl_to_modify" $acl

## Modify ACL on a folder

#TODO

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
#for reference, I've included the LyncUserSettings.cmd file as a springboard in this gist 

## function to assist finding uninstall strings, msi codes, display names of installed applications
# paste into powershell window (or save in (powershell profile)[http://www.howtogeek.com/50236/customizing-your-powershell-profile/]
# usage once loaded: 'Get-Uninstaller chrome'
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
## end of function
