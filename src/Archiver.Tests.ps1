Describe "Move-ToArchive" {
  It "Exists" {
    $result = If (Get-Command Move-ToArchive -ErrorAction SilentlyContinue) {$true} Else {$false};
    $result | Should -be $true;
  }
}
