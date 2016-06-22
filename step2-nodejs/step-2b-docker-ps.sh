#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Let's print the running containers. If you just ran the Docker hello-world, there will be no running container as it exits automatically
printf "\n${yel}Running: docker ps${end}\n"
docker ps
