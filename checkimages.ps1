$RequiredContainers = @('microsoft/nanoserver:latest','stefanscherer/node-windows:6.7.0-nano','nonexisting')
$Containers = Get-ContainerImage | Where-Object {$_.RepoTags -in $RequiredContainers}
if ($Containers.Length -lt $RequiredContainers.Length) {
    foreach($image in $RequiredContainers) {
        $Exist = Get-ContainerImage -ImageIdOrName $image
        if (!$Exist) {
            docker pull $image
        }
    }
}