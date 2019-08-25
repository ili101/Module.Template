## 2.0.2 - 2019/08/26
### Added
* macOS support.
* Azure Test on macOS, Ubuntu and Windows PowerShell Core.
* Azure Badges.

## 2.0.1 - 2019/07/28
### Added
* Linux support.
* Azure DevOps Pipelines test support.
* PowerShell Preview support.
* Publish from Azure option.
* README.md now have instructions.
### Changes
* Triggers ignore .md files and skip tags [skip azp] (for Azure) and/or [skip av] (for AppVeyor).
### Fixed
* Many fixes and code cleanup.

## 1.1.0 - 2018/09/30
### Added
* PowerShell Core support.
* Update-AppveyorBuild -Version.
### Changes
* Pester from PowerShellGallery.
### Fixed
* Compress-Archive replaced with IO.Compression.ZipFile as Compress-Archive don't work on opened files.
* Fix text files encoding.
* AppVeyor Git CRLF encoding fix.

## 1.0.4 - 2018/09/29
### Changes
* Module rename.
* AppVeyor image: Visual Studio 2017.
### Added
* Deploy.ps1 -PowerShellGallery -AppVeyorZip.
* VSCode launch.json PowerShell Pester Tests.
* AppVeyor Get-EnvironmentInfo
### Fixed
* Fixed module name

## 1.0.3 - 2017/10/05
### Added
* PowerShell module structure
* Rearranged files
* Add .psd1 file
* Test-Q Added
### Fixed
* Fixed module name