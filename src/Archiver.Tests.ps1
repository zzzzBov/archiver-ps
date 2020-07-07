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

  $f = New-Item -Path $Path -ItemType File -Force
  
  if ($Created) {
    $f.CreationTime = [DateTime]::Parse($Created)
  }

  if ($Updated) {
    $f.LastWriteTime = [DateTime]::Parse($Updated)
  }

  return $f
}