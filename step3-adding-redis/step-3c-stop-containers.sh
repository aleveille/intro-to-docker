#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# We have named our container with the --name flag, so we can stop it using that name
printf "\n${yel}Running: docker stop step3-nodejs-container step3-redis-container${end}\n"
docker stop step3-nodejs-container step3-redis-container

# Let's print all the containers ever.
printf "\n\n${yel}Running: docker ps -a${end}\n"
docker ps -a

printf "\n\n${yel}Note: we stopped but did not delete the containers. You can run step-3a again and the count will counting from where it left off.${end}\n"
