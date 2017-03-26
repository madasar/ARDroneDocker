docker kill $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)
docker volume rm $(docker volume ls -qf dangling=true)
docker volume rm $(docker volume ls -q)

