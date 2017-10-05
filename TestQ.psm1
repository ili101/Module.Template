#<# Need "Using module TestQ" to work
class Base64z
{
    [string]$ItemName

    Base64z([string]$String) 
    {
        $this.ItemName = $String
    }

    [string]ToString()
    {
        return $this.ItemName
    }
}
#>

#Get-ChildItem -Path $PSScriptRoot | Unblock-File
Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }