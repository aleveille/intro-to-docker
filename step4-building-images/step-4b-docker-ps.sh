#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Let's print the running containers.
printf "\n${yel}Running: docker ps${end}\n"
docker ps
