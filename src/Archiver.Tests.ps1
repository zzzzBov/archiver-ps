$ThisModule = $MyInvocation.MyCommand.Path -replace '\.Tests\.ps1$'
$ThisModuleName = $ThisModule | Split-Path -Leaf
Get-Module -Name $ThisModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$ThisModule.psm1" -Force -ErrorAction Stop
InModuleScope $ThisModuleName {
  Describe "Move-ToArchive" {
    It "Exists" {
      $result = If (Get-Command Move-ToArchive -ErrorAction SilentlyContinue) {$true} Else {$false};
      $result | Should -be $true;
    }
  
    It "Should move old files from the source folder to a subfolder in the archive" {
      $dir = New-Guid
      New-TestFile -Path "TestDrive:\$dir\Downloads\a.txt" -Created "2020-01-01" -Updated "2020-01-01"
      
      Move-ToArchive -From "TestDrive:\$dir\Downloads" -To "TestDrive:\$dir\Archive"

      $archiveResult = Test-Path "TestDrive:\$dir\Archive\2020\01\a.txt"

      $archiveResult | Should -be $true

      $downloadsResult = Test-Path "TestDrive:\$dir\Downloads\a.txt"

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