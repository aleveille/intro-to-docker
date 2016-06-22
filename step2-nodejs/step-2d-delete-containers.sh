#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Similarly as in the previous step, we use the containers's name to manage them
printf "\n${yel}Running: docker rm step2-nodejs-container${end}\n"
docker rm step2-nodejs-container

# Let's print all the containers ever. Our step2-* containers shouldn't be there
printf "\n\n${yel}Running: docker ps -a ${end}\n"
docker ps -a

