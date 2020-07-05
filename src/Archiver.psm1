<#

.SYNOPSIS

Moves files from a source folder to an archive folder organized by year & month.

.DESCRIPTION

Moves files from a specified folder (defaults to downloads) to an archive
folder with subfolders organized by years & months.

.PARAMETER From

Specifies the source folder to archive (defaults to "$home/Downloads").

.PARAMETER To

Specifies the destination folder (defaults to "$home/Archive") where the
archive should be created.

#>

function Move-ToArchive {
  param(
    [string]
    $From,

    [string]
    $To
  )

  Write-Host "Hello, World!!!!"
}

Export-ModuleMember Move-ToArchive
