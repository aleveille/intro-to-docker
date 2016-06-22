#!/bin/sh

# Using color to help you distinguish between comments and commands' output
yel=$'\e[1;33m'
end=$'\e[0m'

printf "\n${yel}Note: the container of this step is not a long running process, there's no need to stop it.${end}\n"
