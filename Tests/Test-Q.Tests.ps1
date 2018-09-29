Describe 'Test-Q' {
    It 'Returns Q' {
        $Q = Test-Q
        $Q | Should -Be Q
    }
    It 'Not returns Y' {
        $Q = Test-Q
        $Q | Should -Not -Be Y
    }
    It 'Bad Test' {
        $Q = Test-Q
        $Q | Should -Be Y
    } -Skip
}