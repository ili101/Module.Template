# Test
PowerShell Test

## Install
From repository
```PowerShell
Install-Module -Name Test -Scope CurrentUser
```
From GitHub
```PowerShell
$Uri = 'https://github.com/ili101/Test/raw/master/Install.ps1' ; & ([Scriptblock]::Create((Invoke-WebRequest -Uri $Uri).Content)) -FromGitHub $Uri-FromGitHub:$true
```

## Contributing
If you fund a bug or added functionality or anything else just fork and send pull requests. Thank you!

## Test-Q
Returns Q

#### Examples:
[Join-Object Test.ps1](https://github.com/ili101/Tests/blob/master/Examples/Test-Q.Examples.ps1)
```PowerShell
Test-Q
```

#### To do:
* Stuff

![](https://raw.githubusercontent.com/ili101/Test/master/Examples/Example1.png)
