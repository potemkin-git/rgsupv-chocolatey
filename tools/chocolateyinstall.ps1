$packageName = "rgsupervision"
$binaryName  = "RG-Setup.exe"
$checkSumType = "md5"

# Regular binary install
$toolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir $binaryName
$checkSum     = "3905f2176c8c6eb7b2866d0efd6af60a" # md5

# Fallback when no Token provided (still deploys binary for further manual installation
$url           = "https://github.com/rgsystemes/rgsupv-chocolatey/raw/main/rgsupv-win.zip"
$url64         = $url
$zipCheckSum   = "7eb82f3f4adaadd126e3f46b56f4fb0f" # md5
$unzipLocation = Join-Path $toolsDir "zip"

##### Requesting required params in not passed as choco install arguments. Expecting: choco install rgsupervision -y --params "'/TOKEN:value /NODE:value'"

$pp = Get-PackageParameters

if (!$pp["Token"]) { $pp["Token"] = Read-Host "Please enter your deployment token:" }
if (!$pp["Node"]) { $pp["Node"] = Read-Host "Please enter the node ID where agent should be deployed (default: root):" }
if (!$pp["Node"]) { $pp["Node"] = "root" }

##### Attempting either binary install or (if no Token provided) simple zip extract

if ([string]::IsNullOrEmpty($pp["Token"])) {
  Write-Error "RG Supervision agent installation cannot be processed without <Token> mandatory parameter."
  Write-Error "You should have used the following command:"
  Write-Error "choco install rgsupervision --params `"'/Token:value(string) /Node:value(int)'`""
  Write-Error "If you do not have your deployment token yet, check your Deployment section within your user profile management page."
  Write-Output "You will then be able to finish the installation by running the following command:"
  Write-Output "$(Join-Path $unzipLocation $binaryName) --action register --login token@token.tk --password <YourToken> --node #$($pp['Node'])"

  Install-ChocolateyZipPackage -PackageName $packageName -Url $url -Url64bit $url64 -UnzipLocation $unzipLocation -Checksum $zipCheckSum -ChecksumType $checkSumType -Checksum64 $zipCheckSum -ChecksumType64 $checkSumType
} else {
  Write-Output "Starting agent install using deployment token: $($pp['Token'])"
  Write-Output $(if ($pp["ExpectedHostName"]) {"Deploying (custom hostname) on node #$($pp['Node'])"} else {"Deploying on node #$($pp['Node'])"})

  $silentArgs = "--action register --login token@token.tk --password $($pp['Token']) --node #$($pp['Node'])"
  if ($pp["ExpectedHostName"]) { $silentArgs += " --expected-host-name $($pp['ExpectedHostName'])" } # ExpectedHostName parameter mainly used for internal debug or on premise requirements

  $packageArgs = @{
    packageName    = $packageName
    fileType       = "exe"
    file           = $fileLocation
    file64         = $fileLocation
    checksum       = $checkSum
    checksum64     = $checkSum
    checksumType   = $checkSumType
    silentArgs     = $silentArgs
    validExitCodes = @(0, 3010, 1641)
    softwareName   = "rgsupervision*"
  }

  Install-ChocolateyInstallPackage @packageArgs
}

