#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Let's print the running containers. If you just ran the Docker hello-world, there will be no running container as it exits automatically
printf "\n${yel}Running: docker ps${end}\n"
docker ps

# Let's print all the containers ever. The hello-world container should show up.
printf "\n\n${yel}Running: docker ps -a${end}\n"
docker ps -a
