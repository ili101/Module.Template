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
1. Create a GitHub Repository (Recommended name is the name of the Module) and clone the repository with VSCode.
2. Clone or download this repository and copy the files to your repository clone.
3. Remove/Replace/Edit/Rename the files `Module.Template.psm1`, `Module.Template.psm1`, `Test-Q.ps1` with your module files.
4. Remove/Replace/Edit/Rename the file `Tests\Test-Q.Tests.ps1` with test for your Module, you can create multiple test files in the folder ending with **.Tests.ps1**.
5. To AppVeyor create an account in https://www.appveyor.com/ and connect it to the GitHub repository, the `appveyor.yml` file is used for the configuration.


[skip azp][skip av]

##  Changelog
[CHANGELOG.md](https://github.com/ili101/Join-Object/blob/master/CHANGELOG.md)

## Contributing
If you fund a bug or added functionality or anything else just fork and send pull requests. Thank you!

## To do
* Noting for now, You can open an Issues if something is needed.

## Examples
[Test-Q.Examples.ps1](https://github.com/ili101/Module.Template/blob/master/Examples/Test-Q.Examples.ps1)
```PowerShell
Test-Q
```

![](https://raw.githubusercontent.com/ili101/Module.Template/master/Examples/Example1.png)