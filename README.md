# Module.Template
Powershell Module Template with GitHub, PowerShellGallery, AppVeyor and Azure DevOps Pipelines integration.<BR />
Can be used as a starting point for your open source Module.

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
$Uri = 'https://raw.githubusercontent.com/ili101/Module.Template/master/Install.ps1'; & ([Scriptblock]::Create((irm $Uri))) -FromGitHub $Uri
```

## Instructions
Returns Q
1

## Examples:
[Test-Q.Examples.ps1](https://github.com/ili101/Module.Template/blob/master/Examples/Test-Q.Examples.ps1)
```PowerShell
Test-Q
```

##  Changelog
[CHANGELOG.md](https://github.com/ili101/Join-Object/blob/master/CHANGELOG.md)

## Contributing
If you fund a bug or added functionality or anything else just fork and send pull requests. Thank you!

## To do
* Noting for now, You can open an Issues if something is needed.

![](https://raw.githubusercontent.com/ili101/Module.Template/master/Examples/Example1.png)