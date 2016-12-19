## *** Examples of exe install***

Execute-Process -Path '<application>.exe' -Parameters '/quiet' -WindowStyle Hidden

Execute-Process -Path "$dirFiles\DirectX\DXSetup.exe" -Parameters '/silent' -WindowStyle 'Hidden'

Execute-Process -Path 'uninstall_flash_player.exe' -Parameters '/uninstall' -WindowStyle Hidden

##***Example to install an msi***

Execute-MSI -Action Install -Path '<application>.msi'

Execute-MSI -Action 'Install' -Path 'Discovery 2015.1.msi'

## Install the base MSI and apply a transform

Execute-MSI -Action Install -Path 'Adobe_Reader_11.0.0_EN.msi' -Transform 'Adobe_Reader_11.0.0_EN_01.mst'

## Install the patch

Execute-MSI -Action Patch -Path 'Adobe_Reader_11.0.3_EN.msp'

## To uninstall an MSI

## Execute-MSI -Action Uninstall -Path '{5708517C-59A3-45C6-9727-6C06C8595AFD}'

## ***Run a vbscript***

Execute-Process -Path "cscript.exe" -Parameters "$dirFiles\whatever.vbs"

##***Remove registry key***

Remove-RegistryKey -Key HKEY_LOCAL_MACHINE\SOFTWARE\Macromedia\FlashPlayer\SafeVersions -Recurse -ContinueOnError:$True

## ***Create a reg key***

Set-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\LMKR\Licensing' -Name 'LMKR_LICENSE_FILE' -Value '@license'-Type String -ContinueOnError:$True

## ***To set an HKCU key***

## [scriptblock]$HKCURegistrySettings = {

## Set-RegistryKey -Key 'HKEY_CURRENT_USER\SOFTWARE\Classes\AppX4hxtad77fbk3jkkeerkrm0ze94wjf3s9' -Name 'NoOpenWith' -Value '""'-Type String -ContinueOnError:$True

## }

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

Remove-File -Path 'C:\Users\Public\Desktop\GeoGraphix Seismic Modeling.lnk'

##***To Create a shortcut***

C:\PS>New-Shortcut -Path "$envProgramData\Microsoft\Windows\Start Menu\My Shortcut.lnk" -TargetPath "$envWinDir\system32\notepad.exe" -IconLocation "$envWinDir\system32\notepad.exe" -Description 'Notepad' -WorkingDirectory "$envHomeDrive\$envHomePath"