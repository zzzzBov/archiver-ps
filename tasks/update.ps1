<#

Write over the existing module file, and then re-import the module.

#>

Copy-Item './Archiver/Archiver.psm1' -Destination "$home/Documents/WindowsPowerShell/Modules/Archiver/"

Import-Module './Archiver/Archiver.psm1' -Force