$ThisModule = $MyInvocation.MyCommand.Path -replace '\.Tests\.ps1$'
$ThisModuleName = $ThisModule | Split-Path -Leaf
Get-Module -Name $ThisModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$ThisModule.psm1" -Force -ErrorAction Stop
InModuleScope $ThisModuleName {
  Describe "Move-ToArchive" {
    BeforeEach {
      $dir = New-Guid
      $path = "TestDrive:\$dir"
      New-Item -Path $path -ItemType Directory -Force
      pushd $path
    }

    AfterEach {
      popd
    }

    It "Exists" {
      $result = If (Get-Command Move-ToArchive -ErrorAction SilentlyContinue) {$true} Else {$false};
      $result | Should -be $true;
    }
  
    It "Should move old files from the source folder to a subfolder in the archive" {
      New-TestFile -Path "Downloads\a.txt" -Created "2020-01-01" -Updated "2020-01-01"
      
      Move-ToArchive -From "Downloads" -To "Archive"

      $archiveResult = Test-Path "Archive\2020\01\a.txt"

      $archiveResult | Should -be $true

      $downloadsResult = Test-Path "Downloads\a.txt"

      $downloadsResult | Should -be $false
    }

    It "Should move old folders from the source folder to a subfolder in the archive" {
      New-TestFile -Path "Downloads\folder\a.txt" -Created "2020-01-01" -Updated "2020-01-01"

      Move-ToArchive -From "Downloads" -To "Archive"

      $archiveResult = Test-Path "Archive\2020\01\folder\a.txt"

      $archiveResult | Should -be $true

      $downloadsResult = Test-Path "Downloads\folder\a.txt"

      $downloadsResult | Should -be $false
    }

    It "Should not move folders from the source folder to a subfolder if the folder contains recent files" {
      $now = Get-Date

      New-TestFile -Path "Downloads\folder\a.txt" -Created "2020-01-01" -Updated "2020-01-01"

      New-TestFile -Path "Downloads\folder\b.txt" -Created $now.ToString("yyyy-MM-dd") -Updated $now.ToString("yyyy-MM-dd")

      Move-ToArchive -From "Downloads" -To "Archive"

      $archiveResult = Test-Path "Archive\2020\01\folder"

      $archiveResult | Should -be $false

      $downloadsResult = Test-Path "Downloads\folder\a.txt"

      $downloadsResult | Should -be $true
    }



    <#
    
    Test cases to try:

    Created date newer than updated date
    null created date
    null updated date
    downloads folder contains symlink
    empty folder

    #>
  }
}

function global:New-TestFile {
  param(
    [string]
    $Path,

    [string]
    $Created,

    [string]
    $Updated
  )

  $parentPath = Split-Path -Path $Path -Parent

  New-TestFolders -Path $parentPath -Created $Created -Updated $Updated

  $f = New-Item -Path $Path -ItemType File


  
  if ($Created) {
    $f.CreationTime = [DateTime]::Parse($Created)
  }

  if ($Updated) {
    $f.LastWriteTime = [DateTime]::Parse($Updated)
  }

  return $f
}

function global:New-TestFolders {
  param(
    [string]
    $Path,

    [string]
    $Created,

    [string]
    $Updated
  )

  $partialPath = $null
  $folders = @()
  foreach ($folder in $Path.split("\")) {
    $partialPath += "$folder\"
    if (!(Test-Path $partialPath)) {
      $newFolder = New-Item -Path $partialPath -ItemType Directory
      $folders += $newFolder

      if ($Created) {
        $newFolder.CreationTime = [DateTime]::Parse($Created)
      }
      
      if ($Updated) {
        $newFolder.LastWriteTime = [DateTime]::Parse($Updated)
      }
    }
  }

  return $folders
}