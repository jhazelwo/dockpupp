#!/bin/sh
#
# files/init.sh - Last-minute changes then start apps.

# If there are modules then add them to the node.
##cat << end_trans > /etc/puppet/manifests/site.pp
cat << end_trans > /etc/puppet/environments/production/manifests/site.pp
node default {
`for this in $(ls /opt/modules); do echo "  include ${this}"; done`
}

end_trans

# Create a default Hiera file using all yaml files in modules.
cat << end_trans > /var/lib/hiera/common.yaml
---
`find /opt/modules -name \*.yaml -o -name \*.yml | xargs cat | egrep '^\w'|sort|uniq`

end_trans

# Run the Puppet master in the background.
/usr/bin/puppet master --verbose --certname=puppet --server=puppet --logdest=/root/puppet.log

# And finally give the user a shell.
/bin/bash

