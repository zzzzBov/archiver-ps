<#

Write over the existing module file, and then re-import the module.

#>

Copy-Item './src/Archiver.psm1' -Destination "$home/Documents/WindowsPowerShell/Modules/Archiver/"

Import-Module './src/Archiver.psm1' -Force