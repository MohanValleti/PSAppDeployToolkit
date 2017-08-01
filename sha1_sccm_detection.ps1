$expected_checksum = "A7BBC4B4F781E04214ECEBE69A766C76681AA7EB"
$file_to_checksum = "c:\windows\notepad.exe"
$Algorithm = "sha1" #must be sha1 or md5

function Get-Checksum {
    Param (
        [string]$File=$(throw("You must specify a filename to get the checksum of.")),
        [ValidateSet("sha1","md5")]
        [string]$Algorithm="sha1"
    )

    $algo = [type]"System.Security.Cryptography.$Algorithm`CryptoServiceProvider"
    [System.BitConverter]::ToString( $sha1.ComputeHash([System.IO.File]::ReadAllBytes($file_to_checksum))).Replace("-", "")
}

if (test-path -PathType Leaf -$file_to_checksum) { $current_checksum = get-checksum -file $file_to_checksum -Algorithm $Algorithm }

if ($expected_checksum -eq $current_checksum) { Write-Host "Installed" }