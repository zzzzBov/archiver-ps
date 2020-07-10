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

  # Setup
  $year = Get-Date -Format "yyyy"
  $month = Get-Date -Format "MM"
  $firstOfMonth = [DateTime]::Parse("$year-$month-01")

  # Read all the files in $From
  $files = Get-ChildItem -Path $From -File

  # Filter out any that are from this month, or any time in the future.

  $oldFiles = $files | Where-Object {$_.LastWriteTime -lt $firstOfMonth}

  # Move the remaining files to $home/Archive subfolders based on their last updated date.

  foreach ($file in $oldFiles) {
    $y = $file.LastWriteTime.ToString("yyyy")
    $m = $file.LastWriteTime.ToString("MM")
    $archive = [IO.Path]::Combine($To, $y, $m)

    if (!(Test-Path $archive)) {
      New-Item -Path $archive -ItemType Directory -Force
    }

    $file | Move-Item -Destination $archive
  }

  # Read all the directories in $From.
  $folders = Get-ChildItem -Path $From -Directory

  # Find each directories' last updated date* and filter out any that are from
  # this month, or any time in the future.
  $oldFolders = $folders | Where-Object {(Get-FolderUpdatedDate $_) -lt $firstOfMonth}

  # Move the remaining directories to $home/Archive subfolders based on their
  # last updated date.
  foreach ($folder in $oldFolders) {
    $date = Get-FolderUpdatedDate $folder

    $y = $date.ToString("yyyy")
    $m = $date.ToString("MM")
    $archive = [IO.Path]::Combine($To, $y, $m)

    if (!(Test-Path $archive)) {
      New-Item -Path $archive -ItemType Directory -Force
    }

    $folder | Move-Item -Destination $archive
  }

  return
}

function Get-FolderUpdatedDate {
  param(
    [IO.DirectoryInfo]
    $folder
  )

  # * Finding a directories' last updated date:

  # Find all items in the directory (including the directory).
  $items = @($folder | Get-ChildItem -Recurse)
  $items += $folder

  # Get the updated date from each item.
  $measure = $items | % {$_.LastWriteTime} | Measure-Object -Maximum

  # Return the latest updated date.
  return $measure.Maximum
}

Export-ModuleMember Move-ToArchive
