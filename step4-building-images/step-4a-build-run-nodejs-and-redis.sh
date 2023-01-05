#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Detecting IP address, your millage may vary
export REDIS_IP=`ipconfig getifaddr en0`

printf "\n${yel}Running:\ndocker run -d \\ \n\t--name step4-redis-container \\ \n\t-p 6379:6379 \\ \n\tredis${end}\n"
docker run -d \
	--name step4-redis-container \
	-p 6379:6379 \
	redis

printf "\n${yel}Running:\ndocker build -t step4-nodejs-image .${end}\n"
docker build -t step4-nodejs-image .

# Start a container in the backup to which we'll pass this directory files, map port 8000 to it and start node (6.0) with the app.js file we just mounted into the image
printf "\n${yel}Running:\ndocker run -d \\ \n\t--name step4-nodejs-container \\ \n\t-p 8000:8000 \\ \n\t--add-host=\"redis:\${REDIS_IP}\" \\ \n\tstep4-nodejs-image${end}\n"
docker run -it --rm \
	--name step4-nodejs-container \
	-p 8000:8000 \
	--add-host="redis:${REDIS_IP}" \
	step4-nodejs-image
