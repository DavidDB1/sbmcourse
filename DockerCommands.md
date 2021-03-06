Start
[https://docs.microsoft.com/en-us/dotnet/core/docker/build-container](https://docs.microsoft.com/en-us/dotnet/core/docker/build-container)

## Docker Commands

    docker ps
    docker run
    docker stop

https://docs.docker.com/engine/reference/commandline/docker/

[https://www.docker.com/sites/default/files/d8/2019-09/docker-cheat-sheet.pdf](https://www.docker.com/sites/default/files/d8/2019-09/docker-cheat-sheet.pdf)

## Start Clean

	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	docker system prune -a -f
	docker images
	#Should be empty
	
## Demo

	#Start Clean		
	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	docker system prune -a
	docker ps
	docker ps -a
	
	#Show Images
	docker images

	#command prompt to directory with .csproj
	
	dotnet publish "MyProject.csproj" -c Release -o /app/publish
	cd app/publish
	
	#copy dockerfile (below) to here	
	docker build -t mydockerimage -f .\DockerFile .

	docker container run -it  -p 5000:5000 --name myrunningcontainer mydockerimage

	docker stop myrunningcontainer 
	docker start myrunningcontainer 
		
	docker tag mydockerimage nuboid/mydockerimage:1.0
	docker logout
	docker login
	docker push nuboid/mydockerimage:1.0

	docker pull nuboid/mydockerimage:1.0
	docker container run -it  -p 5000:5000 --name myrunningcontainer nuboid/mydockerimage:1.0

    http://localhost:5000/weatherforecast
    
    docker rmi nuboid/mydockerimage:1.1

#### DockerFile
    FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS base

    WORKDIR /app

    ENV ASPNETCORE_URLS http://+:5000

    COPY . .
    ENTRYPOINT ["dotnet", "MyResearch.WebApiInDocker.dll"]

## Stop and remove all containers

    docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	
## Images needed

	docker login
	docker pull consul
	docker pull rabbitmq:3-management
	docker pull nuboid/generatebarcodeimage:1.0
	docker pull mongo
	docker pull redis
	
## Parent/Child images

	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)

	docker rmi mybaseimage
	docker rmi mychildimage
	docker rmi python:3-alpine
	docker images

	cd CreateBase
	dir

	docker build -t mybaseimage .
	docker images

	cd ..

	cd CreateChild
	docker build -t mychildimage .
	docker images

	cd ..
	docker run --rm -it -p 8000:8000 mychildimage

http://localhost:8000
	
## Test Redis
	docker container run -it -p 6379:6379 --name rediscontainer redis
	docker exec rediscontainer bash
	redis-cli
	ping
## Exercises
### Ex. 1

https://labs.play-with-docker.com/

	docker images
	docker ps
	docker ps -a
	docker pull nuboid/generatebarcodeimage:1.0

	docker run -d -p 5001:5001 --name mycontainerinstance1 nuboid/generatebarcodeimage:1.0
	docker run -d -p 5002:5001 --name mycontainerinstance2 nuboid/generatebarcodeimage:1.0

	curl --verbose http://localhost:5001/api/barcode/Lorum
	curl --verbose http://localhost:5002/api/barcode/Ipsum

	docker stop mycontainerinstance1
	docker stop mycontainerinstance2

# Also check out
http://demo.portainer.io/#/containers

## Volumes

    docker exec -it generatebarcodecontainer bash
	docker container run -it -v //c/TMP/TESTDIR:/app/mydata -p 5001:5001 --name $runningcontainername $imagename

    -v //c/TMP/TESTDIR:/app/mydata

## Networks

    docker network ls
    docker network inspect bridge
    docker network create --driver bridge mynetwork
    docker container run -it -p 6379:6379 --name rediscontainer --net mynetwork redis
    docker container run -it -v //c/TMP/TESTDIR:/app/mydata -p 5001:5001 --name $runningcontainername --net mynetwork $imagename
    docker network rm mynetwork
	--net mynetwork

## Docker Compose

filename : docker-compose.yml

	version: '3.4'

	services:
	  
	  web:
	   image: "generatebarcodeimage"
	   ports:
	      - "5001:5001"
	   volumes:
	      - //c/TMP/TESTDIR:/app/mydata
	   depends_on: 
	     - rediscontainer
	   networks:
	     - mynetwork

	  rediscontainer:
	    image: "redis"
	    ports:
	       - "6379:6379"
	    networks:
	     - mynetwork

	networks:

	  mynetwork:


   docker-compose up 

## Demo in portainer

	version: '3.2'

	services:
	  
	  web:
	   image: "nuboid/generatebarcodeimage:1.0"
	   ports:
	     - target: 5002
	       published: 5001
	       protocol: tcp
	       mode: host
	  
	   depends_on: 
	     - rediscontainer
	   networks:
	     - mynetwork

	  rediscontainer:
	    image: "redis"
	    ports:
	      - target: 6379
	        published: 6379
	        protocol: tcp
	        mode: host
	    networks:
	     - mynetwork

	networks:

	  mynetwork:
    
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTM2OTE2NzcyNF19
-->