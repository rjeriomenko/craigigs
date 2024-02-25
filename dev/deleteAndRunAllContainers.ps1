docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi test:testtag
docker build -t test:testtag .
docker run -p 6080:80 -v /dev/shm:/dev/shm -e USER=ubuntu test:testtag