#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

# Let's run the official Docker hello-world container. This container runs and exits immediately. It will also explain what happened (image pull, container creation, etc.)
printf "\n${yel}Running: docker run --name step1-helloworld hello-world${end}\n"
docker run --name step1-helloworld hello-world
