<#

Write over the existing module file, and then re-import the module.

#>

$archiveModulePath = "$home/Documents/WindowsPowerShell/Modules/Archiver/"

If (!(Test-Path -Path $archiveModulePath)) {
  New-Item -Path $archiveModulePath -ItemType Directory -Force
}

Copy-Item './Archiver/Archiver.psm1' -Destination $archiveModulePath
Copy-Item './Archiver/Archiver.psd1' -Destination $archiveModulePath

Import-Module './Archiver/Archiver.psm1' -Force
