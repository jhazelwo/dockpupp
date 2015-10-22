#!/bin/sh
#
# files/init.sh - Last-minute changes then start apps.
#
# Let user stop container boot with CRTL-C.
trap "exit 2" 2
#
wait_for_file() {
    # Wait 90 seconds for a file/socket/dir/link
    end="$(($(date '+%s')+90))"
    while [ ! -e $1 ]; do
        test "`date '+%s'`" -gt "${end}" && exit 9
        sleep 1;
    done
}

echo -n "`date` Updating Puppet config"
/usr/bin/puppet config set storeconfigs true
/usr/bin/puppet config set storeconfigs_backend puppetdb
/usr/bin/puppet config set certname puppet
echo "."

echo -n "`date` Adding your modules to this node"
cat << EOF > /etc/puppet/environments/production/manifests/site.pp
node default {
`for this in $(ls /opt/modules); do echo "  include ${this}"; done`
}

EOF
echo "."

echo -n "`date` Creating a default Hiera file using YAML files in your modules"
cat << EOF > /var/lib/hiera/common.yaml
---
`find /opt/modules -name \*.yaml -o -name \*.yml | xargs cat | egrep '^\w'|sort|uniq`

EOF
echo "."

echo "`date` Starting PostgreSQL:"
su - postgres -c "/usr/bin/pg_ctl -D /var/lib/pgsql/data -l /tmp/pg.log start"
wait_for_file /run/postgresql/.s.PGSQL.5432

echo "`date` Running /tmp/puppetdb.sql:"
su - postgres -c "psql -h /run/postgresql -f /tmp/puppetdb.sql"

echo -n "`date` Resetting owner:group of Puppet config files"
chown -R puppet:puppet `puppet config print confdir`
echo "."

echo -n "`date` Starting the Puppet master in the background"
/usr/bin/puppet master --verbose --certname=puppet --server=puppet --logdest=/root/puppet.log
wait_for_file /var/lib/puppet/ssl/certs/ca.pem
wait_for_file /var/lib/puppet/ssl/private_keys/puppet.pem
wait_for_file /var/lib/puppet/ssl/certs/puppet.pem
echo "."

echo "`date` Create SSL files for PuppetDB:"
/usr/libexec/puppetdb/puppetdb-ssl-setup -f

echo -n "`date` Starting PuppetDB"
java_opts="-Xmx192m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/puppetdb/puppetdb-oom.hprof -Djava.security.egd=file:/dev/urandom"
java_jar="-cp /usr/share/puppetdb/puppetdb.jar"
/usr/bin/java ${java_opts} ${java_jar} clojure.main -m com.puppetlabs.puppetdb.core services -c /etc/puppetdb/conf.d &
wait_for_file /var/log/puppetdb/puppetdb.log
echo "."

echo "`date` And finally give the user a shell:"
/bin/bash

