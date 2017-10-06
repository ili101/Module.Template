[CmdLetBinding()]
Param (
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName,

    [ValidateNotNullOrEmpty()]
    [String]$ModulePath,

    [ValidateSet('CurrentUser','AllUsers')]
    [string]
    $Scope = 'CurrentUser'
)

Try 
{
    Write-Verbose -Message 'Module installation started'

    if (!$ModulePath)
    {
        if ($Scope -eq 'CurrentUser')
        {
            $ModulePath = ($Env:PSModulePath -split ';')[0]
        }
        else
        {
            $ModulePath = ($Env:PSModulePath -split ';')[1]
        }
    }
    

    $Files = @(
        '*.dll', 
        '*.psd1', 
        '*.psm1', 
        '*.ps1'
    )
    $ExcludeFiles = @(
        'Install.ps1'
    )
    $ModuleName = [System.IO.Path]::GetFileNameWithoutExtension((Get-ChildItem -File -Filter *.psm1 -Name -Path $PSScriptRoot))

    Set-Location -Path $PSScriptRoot
    $TargetPath = Join-Path -Path $ModulePath -ChildPath $ModuleName

    if (-not (Test-Path -Path $TargetPath)) 
    {
        $null = New-Item -Path $TargetPath -ItemType Directory -ErrorAction Stop
        Write-Verbose -Message "$ModuleName created module folder '$TargetPath'"
    }
    Get-ChildItem -Path $Files -Exclude $ExcludeFiles | ForEach-Object -Process {
        Copy-Item -Path $_ -Destination $TargetPath
        Write-Verbose -Message ("{0} installed module file '{1}'" -f $ModuleName, $_)
    }

    Import-Module -Name TestQ -Force
    Write-Verbose -Message "$ModuleName module installation successful to $TargetPath"
}
Catch 
{
    throw ("Failed installing the module '{0}': {1} in Line {2}" -f $ModuleName, $_, $_.InvocationInfo.ScriptLineNumber)
}