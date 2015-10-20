#!/bin/sh
image="jhazelwo/dockpupp"
#
# Some folks forget to build first; I'll try to do it for you.
docker inspect $image > `mktemp` || ./Build.sh

modules="-v `pwd`/modules:/opt/modules"
#modules="-v /media/sf_GitHub:/usr/share/puppet/modules"
#extra="-v /mnt/foo:/opt/bar"

/usr/bin/docker run --rm --hostname=puppet ${modules} ${extra} -t -i $image

