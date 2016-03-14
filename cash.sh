#!/bin/bash

DEFAULT_IMAGE="node"

declare -A imagemap
imagemap[node]="dev/tinycore7.0-x86_64-node5.7"
imagemap[ruby]="dev/tinycore7.0-x86_64-ruby2.3"
imagemap[groovy]="dev/tinycore7.0-x86_64-groovy2.4"


if [ -e .cashrc ]; then
  echo "Sourcing cashrc"
  cat ./.cashrc
  source ./.cashrc
fi

IMAGE="${1:-$IMAGE}"
IMAGE="${IMAGE:-$DEFAULT_IMAGE}"

CONTAINER_NAME="${PWD##*/}.cash_${IMAGE}"
BUILD_IMAGE=${imagemap[$IMAGE]}
BUILD_VOLUMES="-v ${PWD}:/data -v ${HOME}/.gradle:/root/.gradle -v ${HOME}/.m2:/root/.m2"

function isContainerRunning() {
  docker ps | grep "$1" | wc -l
}

isRunning=`isContainerRunning ${CONTAINER_NAME}`
if [ $isRunning -eq 0 ]; then
  echo "Running $CONTAINER_NAME:$BUILD_IMAGE first time"
  docker run -dt \
    --net=host \
    --name ${CONTAINER_NAME} \
    ${BUILD_VOLUMES} \
    ${BUILD_IMAGE} sh
fi;

docker exec -it ${CONTAINER_NAME} sh -c "PS1=\"${CONTAINER_NAME}.\w > \" sh"
