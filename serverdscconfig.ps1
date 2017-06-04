Configuration MyDscConfiguration {

    param(
        [string[]]$ComputerName="localhost"
    )
    Node $ComputerName {
        WindowsFeature containers { 
             Name = 'Containers' 
             Ensure = 'Present' 
        }

        File DownloadFolder
        {
            Type            = 'Directory'
            DestinationPath = 'c:\downloadsource'
            Ensure          = 'Present'
        }

        Script DownloadScript            
        {            
            GetScript = { @{FilesDownloaded = $(Test-Path -Path 'c:\downloadsource\scripts.zip') } }
            TestScript = { Test-Path -Path 'c:\downloadsource\scripts.zip' }                     
            SetScript = { Invoke-WebRequest '' -OutFile 'c:\downloadsource\scripts.zip' }
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
            SourcePath      = 'c:\downloadsource\docker'
            DestinationPath = 'C:\Program Files\WindowsPowerShell\Modules\Docker'
            Recurse         = $true
            Ensure          = 'Present'
            DependsOn       = '[Archive]UnZipDownload' 
        }

        File DockerMsFtModule
        {
            Type            = 'Directory'
            SourcePath      = 'c:\downloadsource\dockermsftprovider'
            DestinationPath = 'C:\Program Files\WindowsPowerShell\Modules\DockerMsftProvider'
            Recurse         = $true
            Ensure          = 'Present'
            DependsOn       = '[Archive]UnZipDownload' 
        }

        Script InstallDocker            
        {            
            GetScript = { @{FilesDownloaded = $(Test-Path -Path 'c:\downloadsource\scripts.zip') } }
            TestScript = { Test-Path -Path 'c:\downloadsource\scripts.zip' }                     
            SetScript = { Install-Package -Name docker -ProviderName DockerMsftProvider -Force }
            DependsOn = '[File]DockerMsFtModule'            
        }
    }
}

MyDscConfiguration 
