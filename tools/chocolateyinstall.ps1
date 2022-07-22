$packageName = 'rgsupervision'
$toolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$exeFilePath = Join-Path $toolsDir 'RG-Setup.exe'

$url = 'https://dashboard.rg-supervision.com/download/rgsupv-win.zip'
$url64 = 'https://dashboard.rg-supervision.com/download/rgsupv-win.zip'
$md5CheckSumUrl = 'https://dashboard.rg-supervision.com/download/rgsupv-win.zip.md5'
$Response = Invoke-WebRequest -URI $md5CheckSumUrl
$ResponseArray = $Response.toString().Trim().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
$checkSum = $ResponseArray[0]
$checkSumType = 'md5'

$pp = Get-PackageParameters
# Requesting required params in not passed as choco install arguments. Expecting: choco install rgsupervision -y --params "'/TOKEN:value /NODE:value'"
if (!$pp['Token']) { $pp['Token'] = Read-Host 'Please enter your deployment token:' }
if (!$pp['Node']) { $pp['Node'] = Read-Host 'Please enter the node ID where agent should be deployed (default: root):' }

if (!$pp['Node']) { $pp['Node'] = 'root' }

# This will ensure Chocolatey assumes package is installed, so it can be uninstalled properly
# Install-ChocolateyZipPackage does not actually install agent, it only downloads Zip file and puts its content within Tools folder
Install-ChocolateyZipPackage -PackageName $packageName -Url $url -Url64bit $url64 -UnzipLocation $toolsDir -Checksum $checkSum -ChecksumType $checkSumType -Checksum64 $checkSum -ChecksumType64 $checkSumType

if ([string]::IsNullOrEmpty($pp['Token'])) {
  Write-Output "RG Supervision agent installation cannot be processed without <Token> mandatory parameter."
  Write-Output "You should have used the following command:"
  Write-Output "choco install rgsupervision --params "'/Token:value(string) /Node:value(int)'""
  Write-Output "If you do not have your deployment token yet, check your Deployment section within your user profile management page."
  Write-Output "You will then be able to finish the installation by running the following command:"
  Write-Output "$($exeFilePath) --action register --login token@token.tk --password <YourToken> --node #$($pp['Node'])"
} else {
  Write-Output "Starting agent install using deployment token: $($pp['Token'])"
  Write-Output "Deploying on node #$($pp['Node'])" 
  & $exeFilePath --action register --login "token@token.tk" --password "$($pp['Token'])" --node "#$($pp['Node'])" --expected-host-name lisa.staging.rg.gg
}
