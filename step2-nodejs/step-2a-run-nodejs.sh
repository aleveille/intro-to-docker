#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Start a container in the backup to which we'll pass this directory files, map port 8000 to it and start node (6.0) with the app.js file we just mounted into the image
printf "\n${yel}Running:\ndocker run -d \\ \n\t--name step2-nodejs-container \\ \n\t-v "\$PWD":/usr/src/app \\ \n\t-w /usr/src/app \\ \n\t-p 8000:8000 \\ \n\tnode:6.0 \\ \n\tnode app.js${end}\n"


docker run -d \
	--name step2-nodejs-container \
	-v "$PWD":/usr/src/app \
	-w /usr/src/app \
	-p 8000:8000 \
	node:6.0 \
	node app.js


printf "\n${yel}Warning: from now on, containers will run in the background. We'll need to stop them everytime we're ready to move to the next step.${end}\n"
