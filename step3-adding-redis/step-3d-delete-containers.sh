#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Similarly as in the previous step, we use the containers's name to manage them
printf "\n${yel}Running: docker rm step3-nodejs-container step3-redis-container${end}\n"
docker rm step3-nodejs-container step3-redis-container

# Let's print all the containers ever. Our step3-* containers shouldn't be there
printf "\n\n${yel}Running: docker ps -a${end}\n"
docker ps -a

printf "\n\n${yel}Now that you deleted the containers, if you run step-3a again, the counter will start from 0.${end}\n"
