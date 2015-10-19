#!/bin/sh
image="jhazelwo/dockpupp"
#
# Some folks forget to build first; I'll try to do it for you.
docker inspect $image > `mktemp` || ./Build.sh

modules="-v `pwd`/modules:/opt/modules"
hiera="-v `pwd`/hiera:/var/lib/hiera"

/usr/bin/docker run --rm --hostname=puppet ${modules} ${hiera} -t -i $image

