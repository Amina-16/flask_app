param(
    [string]$DockerUser,
    [string]$DockerToken
)
docker login -i $DockerUser -p $DockerToken
docker stop falsk-app -ErrorAction SilentlyContinue
docker rm falsk-app -ErrorAction SilentlyContinue
docker pull $DockerUser/flask_devops_demo:latest
docker run -d --name flask-app -p 5000:5000 $DockerUser/flask_devops_demo:latest