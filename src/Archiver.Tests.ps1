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
  
    It "temporarily should return 1" {
      $result = Move-ToArchive
      $result | Should -be 1
    }
  }
}
