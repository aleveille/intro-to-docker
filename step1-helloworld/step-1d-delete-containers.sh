#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Similarly as in the previous step, we use the containers's name to manage them
printf "\n${yel}Running: docker rm step1-helloword${end}\n"
docker rm step1-helloworld

# Now that we deleted the container, the step1-helloworld container shouldn't be there
printf "\n\n${yel}Running: docker ps -a ${end}\n"
docker ps -a

