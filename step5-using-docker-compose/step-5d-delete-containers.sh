#!/bin/sh

yel=$'\e[1;33m'
end=$'\e[0m'

printf "\n${yel}Note: with docker-compose down the containers are deleted. (There's also docker-compose start and stop that don't create and delete.)${end}\n"
