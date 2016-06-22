#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

printf "\n${yel}Note:\nWe don't need to rebuild the last image, we'll reuse step4-nodejs-image.${end}\n"

# Start a container in the backup to which we'll pass this directory files, map port 8000 to it and start node (6.0) with the app.js file we just mounted into the image
printf "\n${yel}Running: docker-compose up${end}\n"
docker-compose up &
