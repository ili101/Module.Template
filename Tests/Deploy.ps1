<#
    .SYNOPSIS
    Deploy module.
#>
[CmdletBinding(DefaultParameterSetName = 'Default')]
Param
(
    # The name of the module to be deployed, if not provided the name of the .psm1 file in the root folder is used.
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName,

    # Deploy to PowerShellGallery.
    [Parameter(Mandatory, ParameterSetName = 'PowerShellGallery')]
    [Switch]$PowerShellGallery,

    # Key for PowerShellGallery deployment, if not provided $env:NugetApiKey is used.
    [Parameter(ParameterSetName = 'PowerShellGallery')]
    [ValidateNotNullOrEmpty()]
    [String]$NugetApiKey,

    # Skip Version verification for PowerShellGallery deployment, can be used for first release.
    [Parameter(ParameterSetName = 'PowerShellGallery')]
    [Switch]$Force,

    # Upload module as AppVeyor Artifact.
    [Switch]$AppVeyorZip
)
$ErrorActionPreference = 'Stop'

# Get Script Root
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
"[Progress] Deploy Script Start for Module: $ModuleName, Version: $VersionLocal."

# Upload module as AppVeyor Artifact.
if ($env:APPVEYOR -and $AppVeyorZip) {
    $ZipFileName = "{0} {1} {2} {3:yyyy-MM-dd HH-mm-ss}.zip" -f $ModuleName, $VersionLocal, $env:APPVEYOR_REPO_BRANCH, (Get-Date)
    $ZipFileFullPath = Join-Path -Path $ScriptRoot -ChildPath $ZipFileName
    "[Info] AppVeyorZip. $ModuleName, ZipFileName: $ZipFileName."
    $ModulePath = (Get-Module -Name $ModuleName -ListAvailable).ModuleBase | Split-Path
    #Compress-Archive -Path $ModulePath -DestinationPath $ZipFileFullPath
    [System.IO.Compression.ZipFile]::CreateFromDirectory($ModulePath, $ZipFileFullPath, [System.IO.Compression.CompressionLevel]::Optimal, $true)
    Push-AppveyorArtifact $ZipFileFullPath -DeploymentName $ModuleName
}

# Deploy to PowerShell Gallery if run locally OR from AppVeyor & GitHub master
if ((!$env:APPVEYOR -or $env:APPVEYOR_REPO_BRANCH -eq 'master') -and $PowerShellGallery) {
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
        Publish-Module -Name $ModuleName -NuGetApiKey $NugetApiKey -RequiredVersion $VersionLocal
    }
    else {
        '[Info] PowerShellGallery Deploy Skipped (Version Check).'
    }
}
'[Progress] Deploy Ended.'