#!/bin/bash

TAGS=()
TAGS+=(foxy-ex1.13.1-otp24.1.7 foxy-ex1.12.3-otp24.1.5 foxy-ex1.11.4-otp23.3.4)
TAGS+=(dashing-ex1.12.3-otp24.1.5 dashing-ex1.11.4-otp23.3.4 dashing-ex1.10.4-otp23.3.4 dashing-ex1.9.4-otp22.3.4.18)
TAGS+=(galactic-ex1.13.1-otp24.1.7 galactic-ex1.12.3-otp24.1.5 galactic-ex1.11.4-otp23.3.4)
TAGS+=(galactic-ex1.13.1-otp24.1.7 galactic-ex1.12.3-otp24.1.5 galactic-ex1.11.4-otp23.3.4)
TAGS+=(jammy-ex1.12.2-otp24.2.1)

for tag in ${TAGS[@]};
do
  echo ${tag}
  ls Dockerfile.${tag} > /dev/null
  result=$?
  if [ $result -eq 0 ];
  then
    echo "INFO: building ${tag} as target tags os Docker image"
    docker build . -f Dockerfile.${tag} -t rclex/rclex_docker:${tag} --no-cache
    echo ${tag}
    docker run --rm rclex/rclex_docker:${tag} bash -c 'echo ${ROS_DISTRO}'
    docker run --rm rclex/rclex_docker:${tag} bash -c 'mix hex.info'
    sleep 3
    docker push rclex/rclex_docker:${tag}
  else
    echo "ERROR: Docker tag ${tag} does not exist in rclex/rclex_docker"
    exit $result
    fi
done