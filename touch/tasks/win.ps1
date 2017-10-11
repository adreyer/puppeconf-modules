#.DESCRIPTION
#Updates the write time on a list of files similar to the 'touch' command.
#
#.PARAMETER files
#The files to touch
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true,Position=1)]
  [String[]] $files
)

$ErrorActionPreference = "Stop"
$fileresults = @{ }

ForEach ($file in $files) {
	if(Test-Path $file) {
		(Get-Item $file).LastWriteTime = Get-Date
    $fileresults.add($file, @{ "success"  = [bool]$true; "new" = [bool]$true })
	} else {
		echo $null > $file
    $fileresults.add($file, @{ "success" = [bool]$true; "new" = [bool]$false })
}}
ConvertTo-Json -InputObject @{ "files" = $fileresults }
