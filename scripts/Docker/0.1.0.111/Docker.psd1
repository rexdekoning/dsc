#
# Module manifest for module 'Docker'
#
# Generated by: Microsoft Corporation
#

@{

# Script module or binary module file associated with this manifest
RootModule = "Docker.psm1"

# Version number of this module. Gets replaced by appveyor at build time.
ModuleVersion = '0.1.0.111'

Description = "This package contains Docker PowerShell cmdlets that can be used to interact with Windows and Linux Docker hosts."

# Minimum PowerShell version. This should match the reference assembly version
# in project.json (we require 5.0 due to dependencies on parameter completion).
PowerShellVersion = '5.0.0'

# ID used to uniquely identify this module
GUID = '7cc6f829-b4b5-493d-9a99-f92dc54d7e10'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = 'Copyright (c) 2016 Microsoft'

# Type files (.ps1xml) to be loaded when importing this module
#TypesToProcess = 'Docker.PowerShell.Types.ps1xml'

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'Docker.Format.ps1xml'

# Cmdlets to export from this module
CmdletsToExport = @(
    'ConvertTo-ContainerImage',
    'Copy-ContainerFile',
    'Enter-ContainerSession',
    'Export-ContainerImage',
    'Get-Container',
    'Get-ContainerDetail',
    'Get-ContainerImage',
    'Get-ContainerNet',
    'Get-ContainerNetDetail',
    'Import-ContainerImage',
    'New-Container',
    'New-ContainerImage',
    'New-ContainerNet',
    'Remove-Container',
    'Remove-ContainerImage',
    'Remove-ContainerNet',
    'Invoke-ContainerImage',
    'Request-ContainerImage',
    'Add-ContainerImageTag',
    'Start-Container',
    'Start-ContainerProcess',
    'Stop-Container',
    'Submit-ContainerImage',
    'Wait-Container'
)


# Aliases to export from this module
AliasesToExport = @(
    'Attach-Container',
    'Build-ContainerImage',
    'Commit-Container',
    'Exec-Container',
    'Load-ContainerImage',
    'Pull-ContainerImage',
    'Push-ContainerImage',
    'Run-ContainerImage',
    'Save-ContainerImage',
    'Tag-ContainerImage'
)

PrivateData = @{
    PSData = @{
        LicenseUri = "https://raw.githubusercontent.com/Microsoft/Docker-PowerShell/master/LICENSE"

        ProjectUri = "https://github.com/Microsoft/Docker-PowerShell"
    }
}

# HelpInfo
HelpInfoUri="https://github.com/Microsoft/Docker-PowerShell"

}

