# Test
PowerShell Test

| Master | PowerShell Gallery | Beta | Alpha |
|--------|--------------------|------|-------|
|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/master?svg=true)](https://ci.appveyor.com/project/ili101/Test)|[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/TestQ.svg)](https://www.powershellgallery.com/packages/TestQ/) [![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/TestQ.svg)](https://www.powershellgallery.com/packages/TestQ/)|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/Beta?svg=true)](https://ci.appveyor.com/project/ili101/Test)|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/Alpha?svg=true)](https://ci.appveyor.com/project/ili101/Test)|

## Install
From repository
```PowerShell
Install-Module -Name TestQ -Scope CurrentUser
```
From GitHub
```PowerShell
'https://raw.githubusercontent.com/ili101/Test/master/Install.ps1'; & ([Scriptblock]::Create((irm $Uri))) -FromGitHub $Uri
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