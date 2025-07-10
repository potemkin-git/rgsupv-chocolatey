$packageName  = "rgsupervision"
$binaryName   = "RG-Setup.exe"
$checkSumType = "md5"
$toolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir $binaryName # 2.4.108.0
$checkSum     = "134e94dfda2c1689bc4805c101a161a6" # md5 matching 2.4.108.0 binary. Any binary update requires md5 and README.md updates.

##### Requesting required params in not passed as choco install arguments. Expecting: choco install rgsupervision -y --params "'/TOKEN:value /NODE:value'"
$pp = Get-PackageParameters

if (!$pp["Token"]) { $pp["Token"] = Read-Host "Please enter your deployment token:" }
if (!$pp["Node"]) { $pp["Node"] = Read-Host "Please enter the node ID where agent should be deployed (default: root):" }
if (!$pp["Node"]) { $pp["Node"] = "root" }

##### Attempting either binary install or (if no Token provided) simple zip extract

if ([string]::IsNullOrEmpty($pp["Token"])) {
  Write-Error "RG System Suite by Septeo© Supervision agent installation cannot be processed without <Token> mandatory parameter."
  Write-Error "You should have used the following command:"
  Write-Error "choco install rgsupervision --params `"'/Token:value(string) /Node:value(int)'`""
  Write-Error "If you do not have your deployment token yet, check your Deployment section within your user profile management page."
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
    softwareName   = "rgsupervision*"
  }

  Install-ChocolateyInstallPackage @packageArgs
}

