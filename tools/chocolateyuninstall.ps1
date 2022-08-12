If (Test-Path -Path "C:\Program Files (x86)\RG-Supervision\RG_Supervision.exe") {
	$packageArgs = @{
		packageName    = "rgsupervision"
		fileType       = "exe"
		file           = "C:\Program Files (x86)\RG-Supervision\RG_Supervision.exe"
		silentArgs     = "--action uninstall-console"
		validExitCodes = @(0, 3010, 1641)
	}

	Uninstall-ChocolateyPackage @packageArgs
}
