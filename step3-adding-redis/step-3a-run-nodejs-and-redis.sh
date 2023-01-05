#!/bin/sh

# app.js code shamelessly grabbed from http://anandmanisankar.com/posts/docker-container-nginx-node-redis-example/
# thanks Anand Mani Sankar

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Detecting IP address, your millage may vary
export REDIS_IP=`ipconfig getifaddr en0`

printf "\n${yel}Running:\ndocker run -d \\ \n\t--name step3-redis-container \\ \n\t-p 6379:6379 \\ \n\tredis${end}\n"
docker run -d \
	--name step3-redis-container \
	-p 6379:6379 \
	redis

# Start a container in the backup to which we'll pass this directory files, map port 8000 to it and start node (6.0) with the app.js file we just mounted into the image
printf "\n${yel}Running:\ndocker run -d \\ \n\t--name step3-nodejs-container \\ \n\t-v "\$PWD":/usr/src/app \\ \n\t-w /usr/src/app \\ \n\t-p 8000:8000 \\ \n\t--add-host=\"redis:\${REDIS_IP}\" \\ \n\tnode:current \\ \n\tnode app.js${end}\n"

docker run -d \
	--name step3-nodejs-container \
	-v "$PWD":/usr/src/app \
	-w /usr/src/app \
	-p 8000:8000 \
	--add-host="redis:${REDIS_IP}" \
	node:current \
	node app.js
