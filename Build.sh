#!/bin/sh
image="jhazelwo/dockpupp"
docker build --force-rm=true -t "${image}" .
echo "`date` Build complete, use ./Go.sh to start a container from this image."

