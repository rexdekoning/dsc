Configuration MyDscConfiguration {

    param(
        [string[]]$ComputerName="localhost"
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node $ComputerName {
        LocalConfigurationManager
        {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RebootNodeIfNeeded = $true
            ActionAfterReboot = 'ContinueConfiguration'
            AllowModuleOverwrite = $true
        }
 
        File DownloadFolder
        {
            Type            = 'Directory'
            DestinationPath = 'c:\downloadsource'
            Ensure          = 'Present'
        }

        Script DownloadScript            
        {            
            GetScript = {   
                $FilesDownloaded = Test-Path -Path 'c:\downloadsource\scripts.zip'  
                return @{Result = $FilesDownloaded}
            }
            TestScript = { Test-Path -Path 'c:\downloadsource\scripts.zip' }                     
            SetScript = { 
                Write-Verbose -Message 'Download Scripts'
                Invoke-WebRequest 'https://github.com/rexdekoning/dsc/blob/master/scripts.zip?raw=true' -OutFile 'c:\downloadsource\scripts.zip' 
            }
            DependsOn = '[File]DownloadFolder'            
        }

        Archive UnZipDownload
        {
            Path        = 'c:\downloadsource\scripts.zip'
            Destination = 'c:\downloadsource'
            Ensure      = 'Present'
            DependsOn   = '[Script]DownloadScript'
        }

        File DockerModule
        {
            Type            = 'Directory'
            SourcePath      = 'c:\downloadsource\scripts\docker'
            DestinationPath = 'C:\Program Files\WindowsPowerShell\Modules\Docker'
            Recurse         = $true
            Ensure          = 'Present'
            DependsOn       = '[Archive]UnZipDownload' 
        }

        File DockerMsFtModule
        {
            Type            = 'Directory'
            SourcePath      = 'c:\downloadsource\scripts\dockermsftprovider'
            DestinationPath = 'C:\Program Files\WindowsPowerShell\Modules\DockerMsftProvider'
            Recurse         = $true
            Ensure          = 'Present'
            DependsOn       = '[Archive]UnZipDownload' 
        }

        Script ExecutionPolicy
        {
            SetScript = {
                Write-Verbose -Message 'Set Execution Policy'
                Set-ExecutionPolicy RemoteSigned -Force
            }
            TestScript = { $false }
            GetScript  = { @{} }
        }

        Script InstallDocker            
        {            
            GetScript = {@{} }
            TestScript = { 
                $return = $false;
                $service = get-service -name docker -ErrorAction SilentlyContinue
                if ($service) { $return = $true}
                $return
            }                     
            SetScript = { 
                Write-Verbose -Message 'Installing NuGet'
                Install-PackageProvider -Name NuGet -Force
                Write-Verbose -Message 'Installing Docker'
                Install-Package -Name docker -ProviderName DockerMsftProvider -Force 
                Write-Verbose -Message 'Rebooting'
                Restart-Computer -Force
            }
            DependsOn = @('[Script]ExecutionPolicy','[File]DockerMsFtModule')       
        }

        Script InstallLatestDefaultImages           
        {            
            GetScript = {@{} }
            TestScript = { 
                $return = $true;
                $service = get-service -name docker -ErrorAction SilentlyContinue
                if ($service) { $return = $false}
                $return
            }                     
            SetScript = { 
                $RequiredContainers = @('microsoft/nanoserver:latest','stefanscherer/node-windows:6.7.0-nano')
                $Containers = Get-ContainerImage | Where-Object {$_.RepoTags -in $RequiredContainers}
                if ($Containers.Length -lt $RequiredContainers.Length) {
                    foreach($image in $RequiredContainers) {
                        $Exist = Get-ContainerImage -ImageIdOrName $image
                        if (!$Exist) {
                            docker pull $image
                        }
                    }
                }
            }
            DependsOn = '[Script]ExecutionPolicy'
        }
    }
}

MyDscConfiguration 
