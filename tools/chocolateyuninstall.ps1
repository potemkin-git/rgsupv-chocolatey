If (Test-Path -Path "C:\Program Files (x86)\RG-Supervision\RG_Supervision.exe") {
	$packageArgs = @{
		packageName    = "rgsupervision"
		fileType       = "exe"
		file           = "C:\Program Files (x86)\RG-Supervision\RG_Supervision.exe"
		silentArgs     = "--action uninstall-console"
	}

	Uninstall-ChocolateyPackage @packageArgs
}
