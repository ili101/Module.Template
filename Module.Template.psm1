#<# Need "Using module Module.Template" to work
class ExampleClass {
    [string]$ItemName

    ExampleClass([string]$String) {
        $this.ItemName = $String
    }

    [string]ToString() {
        return $this.ItemName
    }
}
#>

#Get-ChildItem -Path $PSScriptRoot | Unblock-File
Get-ChildItem -Path "$PSScriptRoot\*.ps1" -Exclude 'Class.ps1', 'Install.ps1' | ForEach-Object { . $_.FullName }