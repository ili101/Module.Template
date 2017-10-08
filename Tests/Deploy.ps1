#Get-ChildItem Env:
#Get-Variable
"Name is $ModuleName"
'Test 2'
$PSScriptRoot
'Test 3'
[System.IO.Path]::GetFileNameWithoutExtension((Get-ChildItem -File -Filter *.psm1 -Name -Path "$PSScriptRoot\.."))