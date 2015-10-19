#!/bin/sh
#
# 
# If there are modules then add them to the node.
echo "node 'puppet' {" > /etc/puppet/manifests/site.pp
for this in `ls /opt/modules`; do
	echo "  include ${this}" >> /etc/puppet/manifests/site.pp
	ln -s /opt/modules/$this /etc/puppet/modules/$this
done
echo "}" >> /etc/puppet/manifests/site.pp
echo "" >> /etc/puppet/manifests/site.pp
#
# Run the Puppet master in the background.
/usr/bin/puppet master --verbose --certname=puppet --server=puppet --logdest=/root/puppet.log
#
# Make sure we see the banner on log in.
echo "cat /etc/motd" >> /root/.bashrc
#
# And finally give the user a shell.
/bin/bash

