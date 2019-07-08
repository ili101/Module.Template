[CmdLetBinding()]
Param
(
    [Parameter(Mandatory)]
    [String]$Version #= '7.0.0-preview.1'
)
$ErrorActionPreference = 'Stop'

"Installing PowerShell Core..."
"Downloading..."
$MsiPath = Join-Path $env:TEMP "PowerShell-$Version-win-x64.msi"
[System.Net.WebClient]::new().DownloadFile("https://github.com/PowerShell/PowerShell/releases/download/v$Version/PowerShell-$Version-win-x64.msi", $MsiPath)

"Installing..."
Start-Process 'msiexec.exe' -Wait -ArgumentList "/i $MsiPath /quiet"
Remove-Item -Path $MsiPath
$PowerShellFolder = $Version[0]
if ($Version -like "*preview*") {
    $PowerShellFolder += '-preview'
}
$env:Path = "$env:ProgramFiles\PowerShell\$PowerShellFolder;$env:Path"
"PowerShell Core Installed..."