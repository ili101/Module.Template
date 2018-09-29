# Module.Template
Powershell Module Template with GitHub, PowerShellGallery and AppVeyor.

| Master | PowerShell Gallery | Beta | Alpha |
|--------|--------------------|------|-------|
|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/master?svg=true)](https://ci.appveyor.com/project/ili101/Module.Template)|[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Module.Template.svg)](https://www.powershellgallery.com/packages/Module.Template/) [![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/Module.Template.svg)](https://www.powershellgallery.com/packages/Module.Template/)|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/Beta?svg=true)](https://ci.appveyor.com/project/ili101/Module.Template)|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/Alpha?svg=true)](https://ci.appveyor.com/project/ili101/Module.Template)|

## Install
From repository
```PowerShell
Install-Module -Name Module.Template -Scope CurrentUser
```
From GitHub
```PowerShell
'https://raw.githubusercontent.com/ili101/Module.Template/master/Install.ps1'; & ([Scriptblock]::Create((irm $Uri))) -FromGitHub $Uri
```

## Contributing
If you fund a bug or added functionality or anything else just fork and send pull requests. Thank you!

## Test-Q
Returns Q

#### Examples:
[Test-Q.Examples.ps1](https://github.com/ili101/Module.Template/blob/master/Examples/Test-Q.Examples.ps1)
```PowerShell
Test-Q
```

#### To do:
* Stuff

![](https://raw.githubusercontent.com/ili101/Module.Template/master/Examples/Example1.png)