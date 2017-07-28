#!/bin/bash

# Usage: build.sh -d {appDir} -i {imageName} [-t {tag}]

APP_DIR=
IMAGE_NAME=
REPO_TAG=latest

while [[ $# -gt 1 ]]
do
  key=$1

  case $key in
    -d)
      APP_DIR=$2
      shift # past argument
      ;;
    -i)
      IMAGE_NAME=$2
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

usage() {
  echo ""
  echo "Usage: build.sh -d {appDir} -i {imageName} [-t {tag}]"
  echo ""
  echo "appDir    : An absolute path of the directory where project is exists."
  echo "imageName : The name of the image being built."
  echo "tag       : The tag you want to assign to the image being built. When not given 'latest' is used."
  echo ""
}

if [ -z $APP_DIR ] || [ -z $IMAGE_NAME ]
then
  usage
  exit 1
fi

if [[ $APP_DIR != /* ]]
then
  echo "Project path should be absolute."
  exit 1
fi

if [ ! -d $APP_DIR ]
then
  echo "Directory '$APP_DIR' doesn't exists."
  exit 1
fi

# Create .build and .build/app-type/spring-boot-1.4 directories
BUILD_DIR=$APP_DIR/.build
# [ ! -d $BUILD_DIR ] && mkdir $BUILD_DIR;
[ ! -d $BUILD_DIR/app-type/spring-boot-1.4 ] && mkdir -p $BUILD_DIR/app-type/spring-boot-1.4/

echo "Building docker image..."

cp -R `pwd`/docker-build/* $BUILD_DIR/app-type/spring-boot-1.4
cd $APP_DIR && mvn clean package -DskipTests -U

STATUS=$?
if [ $STATUS != 0 ]; then
    echo""
    echo "ERROR :: Maven build is failed...."
    exit -1
fi

cp $APP_DIR/target/*.jar $BUILD_DIR/app.jar
rm -rf $BUILD_DIR/app
cd $BUILD_DIR && unzip -q app.jar -d app
cd $BUILD_DIR && rm -rf app/META-INF/maven
docker build -f $BUILD_DIR/app-type/spring-boot-1.4/Dockerfile -t $IMAGE_NAME:$REPO_TAG $BUILD_DIR/