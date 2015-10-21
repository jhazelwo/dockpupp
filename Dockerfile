FROM centos:7
MAINTAINER jhazelwo@github

RUN yum clean expire-cache && \
 yum update -y && \
 yum install -y wget unzip && \
 rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm && \
 gpg --keyserver keys.gnupg.net --recv-key 1054b7a24bd6ec30 && \
 yum install -y puppet-server-3.8.3 puppet-3.8.3 puppetdb mcollective facter

RUN /usr/bin/puppet cert generate master
RUN /usr/bin/puppet module install puppetlabs-stdlib
RUN /usr/bin/puppet config set environmentpath /etc/puppet/environments/
RUN mkdir -vp /etc/puppet/environments/production/manifests

RUN echo "cat /etc/motd" >> /root/.bashrc

ADD ./files/environment.conf /etc/puppet/environments/production/
ADD ./files/motd /etc/motd

ADD ./files/init.sh /root/
CMD /root/init.sh

