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
    $From = "$home\Downloads\",

    [string]
    $To = "$home\Archive\"
  )

  <#
  
  Read all the files in $From.

  `Get-ChildItem $From -File`

  Filter out any that are from this month, or any time in the future.

  Move the remaining files to $home/Archive subfolders based on their last updated date.

  -----

  Read all the directories in $From.

  `Get-ChildItem $From -Directory`

  Find each directories' last updated date*.

  Filter out any that are from this month, or any time in the future.

  Move the remaining directories to $home/Archive subfolders based on their last updated date.

  -----

  * Finding a directories' last updated date:

  Find all items in the directory (including the directory).
  
  Get the updated date from each item.

  Return the latest updated date.

  #>

  $From
}

Export-ModuleMember Move-ToArchive
