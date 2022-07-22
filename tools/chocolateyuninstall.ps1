Uninstall-ChocolateyZipPackage 'rgsupervision' 'rgsupv-win.zip'

If (Test-Path -Path "C:\Program Files (x86)\RG-Supervision\RG_Supervision.exe") {
	& "C:\Program Files (x86)\RG-Supervision\RG_Supervision.exe" --action uninstall-console
}
