#!/bin/bash

# Usage: deploy.sh -i {imageName} -r {repositoryName} [-t {tag}]

usage() {
  echo ""
  echo "Usage: deploy.sh -i {imageName[:tag]} -r {repositoryName} [-t {tag}]"
  echo ""
  echo "imageName      : The name of the source docker image (optionally with tag) you want to deploy on docker repository. e.g. hisab-contact"
  echo "                 If you have multiple images available with same name and different tag, it is recommended to pass tag as well. e.g. hisab-contact:1.0.0"
  echo "                 When no tag is specified explicitly, image with 'latest' tag is used as source image."
  echo "repositoryName : The full path of the docker repository. e.g. 'docker-snapshot.dreamworld.solutions/hisab/hisab-contact'"
  echo "tag            : The tag you want to assign to the image being deployed to docker repository. When not given 'latest' is used."
  echo ""
}

IMAGE_NAME=
IMAGE_TAG=latest
REPO_NAME=
REPO_TAG=latest

while [[ $# -gt 1 ]]
do
  key=$1

  case $key in
    -i)
      IMAGE_NAME=$2
      if [[ $IMAGE_NAME == *":"* ]]
      then
        IMAGE_TAG=$(echo $IMAGE_NAME| cut -d':' -f 2)
        IMAGE_NAME=$(echo $IMAGE_NAME| cut -d':' -f 1)        
      fi
      [ -z $IMAGE_TAG ] && echo "Invalid image tag." && exit 1
      shift # past argument
      ;;
    -r)
      REPO_NAME=$2
      shift # past argument
      ;;
    -t)
      REPO_TAG=$2
      shift # past argument
      ;;
    *)
      # unknown option
      ;;
  esac

  shift # past argument or value
done

if [ -z $IMAGE_NAME ] || [ -z $REPO_NAME ]
then
  usage
  exit 1
fi

echo "Pushing docker image to docker repository..."

DOCKER_USER=admin
DOCKER_PASS=admin123
DOCKER_HOST=$(echo $REPO_NAME| cut -d'/' -f 1)
IMAGE_ID=$(docker images -q $IMAGE_NAME:$IMAGE_TAG)

[ -z $IMAGE_ID ] && echo "'IMAGE ID' is not resolved for image '$IMAGE_NAME:$IMAGE_TAG'." && exit 1

docker tag $IMAGE_ID $REPO_NAME:$REPO_TAG
docker login -u=$DOCKER_USER -p=$DOCKER_PASS $DOCKER_HOST
docker push $REPO_NAME:$REPO_TAG