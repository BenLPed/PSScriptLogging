# Indlæs public/private automatisk
Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Filter *.ps1 | ForEach-Object { . $_.FullName }
Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public')  -Filter *.ps1 | ForEach-Object { . $_.FullName }

# Eksporter kun Public-funktioner
$public = (Get-ChildItem (Join-Path $PSScriptRoot 'Public') -Filter *.ps1).BaseName
Export-ModuleMember -Function $public
