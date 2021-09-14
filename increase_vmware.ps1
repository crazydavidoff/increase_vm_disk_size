$vCenter = Read-Host -Prompt 'vCenter host'
$User = Read-Host -Prompt 'Username'
$Password = Read-Host -Prompt 'Password' -AsSecureString
$NewSizeGB = Read-Host -Prompt 'Size in GB'
$default=2
if (!($value = Read-Host "Hard disk number [$default]")) { $value = $default }
$hosts='vmlist'

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($BSTR)

$vms = Get-Content $hosts

Write-Host "The following will be done on:"
Write-Host $vms

$confirmation = Read-Host "Are you sure you want to proceed [y/n]"
if ($confirmation -eq 'y') {

Connect-VIServer -Server $vCenter -User $User -password $PlainPassword

foreach ($vm in $vms) {
VMware.VimAutomation.Core\Get-VM $vm | VMware.VimAutomation.Core\Get-HardDisk | Where-Object {$_.name -eq "Hard disk $value"}| VMware.VimAutomation.Core\Set-HardDisk -Confirm:$false -capacityGB $NewSizeGB
}
Disconnect-VIServer -Confirm:$false
}
