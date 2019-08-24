# Module.Template
Powershell Module Template with GitHub, PowerShellGallery, AppVeyor and Azure DevOps Pipelines integration.<BR />
Can be used as a starting point for your open source Module.

| Master | PowerShell Gallery | Beta | Alpha |
|--------|--------------------|------|-------|
|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/master?svg=true)](https://ci.appveyor.com/project/ili101/Module.Template)|[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Module.Template.svg)](https://www.powershellgallery.com/packages/Module.Template/) [![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/Module.Template.svg)](https://www.powershellgallery.com/packages/Module.Template/)|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/Beta?svg=true)](https://ci.appveyor.com/project/ili101/Module.Template)|[![Build status](https://ci.appveyor.com/api/projects/status/fyuu9hnl68ttn35n/branch/Alpha?svg=true)](https://ci.appveyor.com/project/ili101/Module.Template)|

## Install
From repository (Recommended)
```PowerShell
Install-Module -Name Module.Template -Scope CurrentUser
```
From GitHub Branch (For testing)
```PowerShell
$Uri = 'https://raw.githubusercontent.com/ili101/Module.Template/master/Install.ps1'; & ([Scriptblock]::Create((irm $Uri))) -FromGitHub $Uri
```

## Instructions
### Setup
1. Create a GitHub Repository (Recommended name is the name of the Module) and clone the repository with VSCode.
2. Clone or download this repository and copy the files to your repository clone.
3. Remove/Replace/Edit/Rename the files `Module.Template.psm1`, `Module.Template.psm1`, `Test-Q.ps1`, `Class.ps1` with your module files.
4. Remove/Replace/Edit/Rename the file `Tests\Test-Q.Tests.ps1` with tests for your Module, you can create multiple test files in the folder ending with **.Tests.ps1**.
5. Edit `README.md`, `CHANGELOG.md` and the `Examples` folder to provide documentation for the Module.
6. `Install.ps1` is used to "build" the module and put it in the PowerShell Modules folder, adjust the `$IncludeFiles` and `$ExcludeFiles` variables if needed to configure which files and folders to copy from the source root folder. Can be used locally by executing `Install.ps1` or remotely from GitHub by the Install command mentiond in the `README.md`. (Also used in the CI procedure).
7. To use AppVeyor create an account on https://www.appveyor.com/ and connect it to the GitHub repository, the `appveyor.yml` file is used for the configuration.
8. To use Azure DevOps Pipelines create an account on https://dev.azure.com and connect it to the GitHub repository, the `azure-pipelines.yml` file is used for the configuration.
### CI Configuration and usage
**Triggers** - When Pushing a Commit to GitHub AppVeyor and Azure will be triggered unless the Commit contain only changes to the **.md** files or the skip tags [skip azp] (for Azure) and/or [skip av] (for AppVeyor) are added to the Commit name.<BR />
This behavior can be adjusted in the .yml files (`azure-pipelines.yml` do not support wildcards in the file names under trigger:paths:exclude).<BR />
Additionally to run a quick test locally in VSCode click F5 (verify debug is set to "PowerShell Pester Tests" in the debug section, this is set in `.vscode\launch.json`)

**PowerShell Version and OS** - AppVeyor set to test on Ubuntu, Windows Framework and Windows Core.<BR />
For Windows Core you can control the version by setting it in the line `- ps: '& .\Tests\InstallPowerShell.ps1 -Version "7.0.0-preview.2"'` or comment the line out to use the default version.
For Ubuntu you can change or comment out the line with the `sudo apt-get install -y powershell-preview`.<BR />
Azure test on Windows Framework and Ubuntu, add/remove jobs in the .yml file to change it.

**Test Results** - The Pester test results are published to AppVeyor Tests tab by the `.\Tests\CI.ps1 -Finalize` line, and to the Azure Tests tab by the `PublishTestResults@2` task.

**Artifacts** - Artifacts are Zip files created for later use, Artifact with the Windows Framework Module is uploaded to the AppVeyor Artifacts tab by the `.\Tests\CI.ps1 -Artifact` line, Artifact with the Windows Framework Module and Artifact with the Git Source is uploaded to Azure by the `.\Tests\CI.ps1 -Artifact` segment.

**Publish** - You can publish the Module to the PowerShell Gallery in 3 ways.<BR />
1. AppVeyor will publish the module automatically if the commit is made in the GitHub master branch and the module version in the .psd file is newer from the version in the gallery.<BR />
For this to work you need to go to [AppVeyor](https://www.appveyor.com/) > project > settings and under Environment add an "encrypted" environment variable named "NugetApiKey" with your PowerShell Gallery Key.<BR />
To disable this comment out the `- ps: '$null = Install-PackageProvider -Name NuGet -Force ; & .\Tests\Publish.ps1'` line

2. In Azure you can publish the module manually from an Artifacts. For this to work you need to configure a "Releases" in Azure, I didn't find a way to configure it in the .yml, but I exported it to json `Tests\Azure Publish config.json`, import it in [Azure](https://dev.azure.com) > Releases (You may need to create an empty releases, save it, view releases, New > Import and delete the empty release. Microsoft can create the worst interfaces known to man), if after importing something show in red fix it and if in the Artifacts stage the "Publish" points to "Module.Template" delete "Publish" and create it again pointing to your Project. (You can delete the `Tests\Azure Publish config.json` file). Then in the release configuration Variable tab add a "Secret" "Publish Stage" pipeline variable named "NugetApiKey" with your PowerShell Gallery Key.<BR />
To publish click "Create a new release" and select the Build version containing the Artifact to use for the release.

3. You can also run `Tests\Publish.ps1` locally with `-NugetApiKey <Key>`

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