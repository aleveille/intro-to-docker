#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# We have named our container with the --name flag, so we can stop it using that name
printf "\n${yel}Running: docker stop step2-nodejs-container${end}\n"
docker stop step2-nodejs-container

# Let's print all the containers ever. The container step2-nodejs-container will show, but its status should be Exited(0) 
printf "\n\n${yel}Running: docker ps -a${end}\n"
docker ps -a
