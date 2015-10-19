#!/bin/sh
modules="-v `pwd`/modules:/opt/modules"
hiera="-v `pwd`/hiera:/var/lib/hiera"

/usr/bin/docker run --rm --hostname=puppet ${modules} ${hiera} -t -i jhazelwo/dockpupp

