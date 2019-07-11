# Remove BOM from the file
[CmdLetBinding()]
Param (
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName,

    [ValidateNotNullOrEmpty()]
    [String]$ModulePath,

    [ValidateNotNullOrEmpty()]
    [Uri]$FromGitHub,

    [ValidateSet('CurrentUser', 'AllUsers')]
    [string]
    $Scope = 'CurrentUser'
)

# Set Include/Exclude Files
$IncludeFiles = @(
    '*.dll',
    '*.psd1',
    '*.psm1',
    '*.ps1',
    'morelinq*'
)
$ExcludeFiles = @(
    'Install.ps1'
)

function Invoke-MultiLike {
    [alias("LikeAny")]
    [CmdletBinding()]
    param
    (
        $InputObject,
        [Parameter(Mandatory)]
        [String[]]$Filters,
        [Switch]$Not
    )
    $FiltersRegex = foreach ($Filter In $Filters) {
        $Filter = [regex]::Escape($Filter)
        if ($Filter -match "^\\\*") {
            $Filter = $Filter.Remove(0, 2)
        }
        else {
            $Filter = '^' + $Filter
        }
        if ($Filter -match "\\\*$") {
            $Filter = $Filter.Substring(0, $Filter.Length - 2)
        }
        else {
            $Filter = $Filter + '$'
        }
        $Filter
    }
    if ($Not) {
        $InputObject -notmatch ($FiltersRegex -join '|').replace('\*', '.*').replace('\?', '.')
    }
    else {
        $InputObject -match ($FiltersRegex -join '|').replace('\*', '.*').replace('\?', '.')
    }
}

Try {
    Write-Verbose -Message 'Module installation started'

    if (!$ModulePath) {
        if ($Scope -eq 'CurrentUser') {
            $ModulePathIndex = 0
        }
        else {
            $ModulePathIndex = 1
        }
        if ($IsLinux) {
            $ModulePathSeparator = ':'
        }
        else {
            $ModulePathSeparator = ';'
        }
        $ModulePath = ($Env:PSModulePath -split $ModulePathSeparator)[$ModulePathIndex]
    }

    # Get $ModuleName, $TargetPath, [$Links]
    if ($FromGitHub) {
        # Fix Could not create SSL/TLS secure channel
        #$SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol
        #[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $WebClient = [System.Net.WebClient]::new()
        $GitUri = $FromGitHub.AbsolutePath.Split('/')[1, 2] -join '/'
        $GitBranch = $FromGitHub.AbsolutePath.Split('/')[3]
        $Links = (Invoke-RestMethod -Uri "https://api.github.com/repos/$GitUri/contents" -Body @{ref = $GitBranch }) | Where-Object { (LikeAny $_.name $IncludeFiles) -and (LikeAny $_.name $ExcludeFiles -Not) }

        $ModuleName = [System.IO.Path]::GetFileNameWithoutExtension(($Links | Where-Object { $_.name -like '*.psm1' }))
        $ModuleVersion = (. ([Scriptblock]::Create((Invoke-WebRequest -Uri ($Links | Where-Object { $_.name -eq "$ModuleName.psd1" }).download_url)))).ModuleVersion
    }
    else {
        $ModuleName = [System.IO.Path]::GetFileNameWithoutExtension((Get-ChildItem -File -Filter *.psm1 -Name -Path $PSScriptRoot))
        $ModuleVersion = (. ([Scriptblock]::Create((Get-Content -Path "$PSScriptRoot\$ModuleName.psd1" | Out-String)))).ModuleVersion
    }
    $TargetPath = Join-Path -Path $ModulePath -ChildPath $ModuleName
    $TargetPath = Join-Path -Path $TargetPath -ChildPath $ModuleVersion

    # Create Directory
    if (-not (Test-Path -Path $TargetPath)) {
        $null = New-Item -Path $TargetPath -ItemType Directory -ErrorAction Stop
        Write-Verbose -Message ('Created module folder: "{0}"' -f $TargetPath)
    }

    # Copy Files
    if ($FromGitHub) {
        foreach ($Link in $Links) {
            $TargetPathItem = Join-Path -Path $TargetPath -ChildPath $Link.name
            if ($Link.type -ne 'dir') {
                $WebClient.DownloadFile($Link.download_url, $TargetPathItem)
                Write-Verbose -Message ('Installed module file: "{1}"' -f $Link.name)
            }
            else {
                if (-not (Test-Path -Path $TargetPathItem)) {
                    $null = New-Item -Path $TargetPathItem -ItemType Directory -ErrorAction Stop
                    Write-Verbose -Message 'Created module folder: "{0}"' -f $TargetPathItem
                }
                $SubLinks = (Invoke-RestMethod -Uri $Link.git_url -Body @{recursive = '1' }).tree
                foreach ($SubLink in $SubLinks) {
                    $TargetPathSub = Join-Path -Path $TargetPathItem -ChildPath $SubLink.path
                    if ($SubLink.'type' -EQ 'tree') {
                        if (-not (Test-Path -Path $TargetPathSub)) {
                            $null = New-Item -Path $TargetPathSub -ItemType Directory -ErrorAction Stop
                            Write-Verbose -Message 'Created module folder: "{0}"' -f $TargetPathSub
                        }
                    }
                    else {
                        $WebClient.DownloadFile(
                            ('https://raw.githubusercontent.com/{0}/{1}/{2}/{3}' -f $GitUri, $GitBranch, $Link.name, $SubLink.path),
                            $TargetPathSub
                        )
                    }
                }
            }
        }
    }
    else {
        Get-ChildItem -Path $PSScriptRoot -Exclude $ExcludeFiles | Where-Object { LikeAny $_.Name $IncludeFiles } | ForEach-Object {
            if ($_.Attributes -ne 'Directory') {
                Copy-Item -Path $_ -Destination $TargetPath
                Write-Verbose -Message ('Installed module file "{0}"' -f $_)
            }
            else {
                Copy-Item -Path $_ -Destination $TargetPath -Recurse -Force
                Write-Verbose -Message ('Installed module folder "{0}"' -f $_)
            }
        }
    }

    # Import Module
    Write-Verbose -Message "$ModuleName module installation successful to $TargetPath"
    Import-Module -Name $ModuleName -Force
    Write-Verbose -Message "Module installed"
}
Catch {
    throw ('Failed installing the module "{0}": {1} in Line {2}' -f $ModuleName, $_, $_.InvocationInfo.ScriptLineNumber)
}
finally {
    #if ($FromGitHub) {
    #    [Net.ServicePointManager]::SecurityProtocol = $SecurityProtocol
    #}
    Write-Verbose -Message 'Module installation end'
}