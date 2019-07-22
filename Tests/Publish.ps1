<#
    .SYNOPSIS
    Deploy module to PowerShellGallery.
#>
[CmdletBinding(DefaultParameterSetName = 'ModuleName')]
Param
(
    # The name of the module to be deployed, if not provided the name of the .psm1 file in the parent folder is used.
    [Parameter(ParameterSetName = 'ModuleName')]
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName,

    # Publish module from path, if not provided the installed module is used.
    [Parameter(Mandatory, ParameterSetName = 'Path')]
    [ValidateNotNullOrEmpty()]
    [String]$Path,

    # Key for PowerShellGallery deployment, if not provided $env:NugetApiKey is used.
    [ValidateNotNullOrEmpty()]
    [String]$NugetApiKey,

    # Skip Version verification for PowerShellGallery deployment, can be used for first release.
    [Switch]$Force
)
$ErrorActionPreference = 'Stop'

# Get Script Root
if ($Path) {
    $Psd1Path = (Get-ChildItem -File -Filter *.psd1 -Path $Path -Recurse)[0].FullName
    $ModuleName = [System.IO.Path]::GetFileNameWithoutExtension($Psd1Path)
    $VersionLocal = (. ([Scriptblock]::Create((Get-Content -Path $Psd1Path | Out-String)))).ModuleVersion
}
else {
    if ($PSScriptRoot) {
        $ScriptRoot = $PSScriptRoot
    }
    elseif ($psISE.CurrentFile.IsUntitled -eq $false) {
        $ScriptRoot = Split-Path -Path $psISE.CurrentFile.FullPath
    }
    elseif ($null -ne $psEditor.GetEditorContext().CurrentFile.Path -and $psEditor.GetEditorContext().CurrentFile.Path -notlike 'untitled:*') {
        $ScriptRoot = Split-Path -Path $psEditor.GetEditorContext().CurrentFile.Path
    }
    else {
        $ScriptRoot = '.'
    }

    # Get Module Info
    if (!$ModuleName) {
        $ModuleName = [System.IO.Path]::GetFileNameWithoutExtension((Get-ChildItem -File -Filter *.psm1 -Name -Path (Split-Path $ScriptRoot)))
    }
    $VersionLocal = ((Get-Module -Name $ModuleName -ListAvailable).Version | Measure-Object -Maximum).Maximum
}

"[Progress] Deploy Script Start for Module: $ModuleName, Version: $VersionLocal."

# Deploy to PowerShell Gallery if run locally OR from AppVeyor & GitHub master
if (!$env:APPVEYOR -or $env:APPVEYOR_REPO_BRANCH -eq 'master') {
    if ($env:APPVEYOR) {
        $Success = $true
        $AppVeyorProject = Invoke-RestMethod -Uri "https://ci.appveyor.com/api/projects/$env:APPVEYOR_ACCOUNT_NAME/$env:APPVEYOR_PROJECT_SLUG"
        $AppVeyorProject.build.jobs | ForEach-Object {
            '[Info] AppVeyor job name: "{0}", Id: {1}, Status: {2}.' -f $_.name, $_.jobId, $_.status
            if ($_.jobId -ne $env:APPVEYOR_JOB_ID -and $_.status -ne "success") {
                $Success = $false
            }
        }
        if (!$Success) {
            '[Info] There are filed jobs skipping PowerShell Gallery deploy.'
            break
        }
    }
    try {
        $VersionGallery = (Find-Module -Name $ModuleName -ErrorAction Stop).Version
    }
    catch {
        if ($_.Exception.Message -notlike 'No match was found for the specified search criteria*' -or !$Force) {
            throw $_
        }
    }

    "[Info] PowerShellGallery. $ModuleName, VersionGallery: $VersionGallery, VersionLocal: $VersionLocal."
    if ($VersionGallery -lt $VersionLocal -or $Force) {
        if (!$NugetApiKey) {
            $NugetApiKey = $env:NugetApiKey
        }
        "[Info] PowerShellGallery. Deploying $ModuleName version $VersionLocal."
        if ($Path) {
            Publish-Module -NuGetApiKey $NugetApiKey -Path $Psd1Path
        }
        else {
            Publish-Module -NuGetApiKey $NugetApiKey -Name $ModuleName  -RequiredVersion $VersionLocal
        }
    }
    else {
        '[Info] PowerShellGallery Deploy Skipped (Version Check).'
    }
}
else {
    '[Info] PowerShellGallery Deploy Skipped.'
}
'[Progress] Deploy Ended.'