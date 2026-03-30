param(
    [string]$DockerUser,
    [string]$DockerToken
)

$ErrorActionPreference = "Stop"
$ContainerName = "flask-app"
$ImageName = "$DockerUser/flask_devops_demo:latest"

if ([string]::IsNullOrWhiteSpace($DockerUser) -or [string]::IsNullOrWhiteSpace($DockerToken)) {
    throw "DockerUser and DockerToken are required."
}

$DockerToken | docker login --username $DockerUser --password-stdin
if ($LASTEXITCODE -ne 0) {
    throw "Docker login failed."
}

# Ignore stop/remove errors if the container does not exist yet.
docker stop $ContainerName 2>$null | Out-Null
docker rm $ContainerName 2>$null | Out-Null

docker pull $ImageName
if ($LASTEXITCODE -ne 0) {
    throw "Docker pull failed for image: $ImageName"
}

docker run -d --name $ContainerName -p 5000:5000 --restart unless-stopped $ImageName
if ($LASTEXITCODE -ne 0) {
    throw "Docker run failed for image: $ImageName"
}
