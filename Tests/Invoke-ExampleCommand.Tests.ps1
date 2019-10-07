#Requires -Modules Pester

Describe 'Invoke-ExampleCommand' {
    It 'Returns example string' {
        Invoke-ExampleCommand | Should -BeLike 'This is an example*'
    }
    It 'Not returns Foo' {
        Invoke-ExampleCommand | Should -Not -Be 'Foo'
    }
    It 'Skipped Test' {
        Invoke-ExampleCommand | Should -Be 'WIP'
    } -Skip
}