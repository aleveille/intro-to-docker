#!/bin/sh

yel=$'\e[1;33m'
end=$'\e[0m'

printf "\n${yel}Running:\ndocker compose down${end}\n"
docker-compose down
