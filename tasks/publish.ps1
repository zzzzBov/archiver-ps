function Publish-ToPowerShellGallery {
  param(
    [Parameter(Mandatory)]
    [string]
    $NuGetApiKey
  )

  Publish-Module -Name 'Archiver' -NuGetApiKey $NuGetApiKey
}

Publish-ToPowerShellGallery
