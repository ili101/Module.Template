[CmdLetBinding()]
Param (
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName,
    [ValidateScript({
                Test-Path -Path $_ -Type Container
    })]
    [String]$ModulePath = ($Env:PSModulePath -split ';')[0]
)

Try 
{
    Write-Verbose -Message "$ModuleName module installation started"

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
}
Catch 
{
    throw "Failed installing the module '$ModuleName': $_"
}

Try 
{
    Set-Location -Path $PSScriptRoot
    $TargetPath = Join-Path -Path $ModulePath -ChildPath $ModuleName

    if (-not (Test-Path -Path $TargetPath)) 
    {
        $null = New-Item -Path $TargetPath -ItemType Directory -ErrorAction Stop
        Write-Verbose -Message "$ModuleName created module folder '$TargetPath'"
    }
    Get-ChildItem -Path $Files -Exclude $ExcludeFiles | ForEach-Object -Process {
        Copy-Item -Path $_ -Destination $TargetPath
        Write-Verbose -Message ("{0} installed module file '{1}'" -f $ModuleName, $_.Name)
    }
    Write-Verbose -Message "$ModuleName module installation successful"
}
Catch 
{
    throw "Failed installing the module '$ModuleName': $_"
}
Import-Module -Name TestQ -Force