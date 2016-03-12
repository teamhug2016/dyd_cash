#!/bin/bash

DEFAULT_IMAGE="node5"

declare -A imagemap
imagemap[node5]="dev/node5.7"

IMAGE="${1:-$DEFAULT_IMAGE}"
CONTAINER_NAME="${PWD##*/}.cash_${IMAGE}"
BUILD_IMAGE=${imagemap[$IMAGE]}
BUILD_VOLUMES="-v ${PWD}:/data"

function isContainerRunning() {
  docker ps | grep "$1" | wc -l
}

isRunning=`isContainerRunning ${CONTAINER_NAME}`
if [ $isRunning -eq 0 ]; then
  echo "Running $CONTAINER_NAME first time"
  docker run -dt \
    --net=host \
    --name ${CONTAINER_NAME} \
    ${BUILD_VOLUMES} \
    ${BUILD_IMAGE} sh
fi;

docker exec -it ${CONTAINER_NAME} sh -c "PS1=\"${CONTAINER_NAME}.\w > \" sh"
