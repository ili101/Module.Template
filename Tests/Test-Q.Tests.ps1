# imports the Get-Planet function into local scope
#. $PSScriptRoot\Get-Planet.ps1
#. $PSScriptRoot\..\Install.ps1

# To run the tests run the script file, 
# for example by pressing F5.
Describe 'Test-Q' {
    It 'Returns Q' {
        $Q = Test-Q
        $Q | Should -Be Q
    }
}