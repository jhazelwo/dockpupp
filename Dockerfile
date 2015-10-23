FROM centos:7
MAINTAINER jhazelwo@github

RUN yum clean expire-cache && \
 yum -y update && \
 yum -y install wget unzip && \
 yum -y install postgresql postgresql-server postgresql-devel postgresql-docs postgresql-contrib && \
 rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm && \
 gpg --keyserver keys.gnupg.net --recv-key 1054b7a24bd6ec30 && \
 yum -y install puppet-server-3.8.3 puppet-3.8.3 puppetdb mcollective facter puppetdb-terminus

RUN /usr/bin/puppet cert generate master
RUN /usr/bin/puppet module install puppetlabs-stdlib
RUN /usr/bin/puppet config set environmentpath /etc/puppet/environments/
RUN /usr/bin/puppet config set storeconfigs true
RUN /usr/bin/puppet config set storeconfigs_backend puppetdb
RUN /usr/bin/puppet config set certname puppet
RUN mkdir -vp /etc/puppet/environments/production/manifests

RUN echo "cat /etc/motd" >> /root/.bashrc

ADD ./files/routes.yaml /etc/puppet/routes.yaml
ADD ./files/environment.conf /etc/puppet/environments/production/
ADD ./files/motd /etc/motd

RUN su - postgres -c "pg_ctl initdb"
ADD ./files/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf
ADD ./files/puppetdb.conf /etc/puppet/puppetdb.conf
ADD ./files/database.ini /etc/puppetdb/conf.d/database.ini
ADD ./files/puppetdb.sql /tmp/puppetdb.sql

ADD ./files/init.sh /root/
CMD /root/init.sh

