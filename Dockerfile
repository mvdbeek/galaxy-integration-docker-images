######################################################
#
# Galaxy DRM Base Image
# Based on agaveapi/centos-base
#
# This container creates a testuser user with a ssh key and password
# equal to the username. A SSH server and supervisord are installed.
#
# Usage:
# docker run -v docker.example.com -i     \
#            -p 10022:22                  \ # SSHD, SFTP
#            mvdbeek/centos-base
#
######################################################

FROM centos:centos8

MAINTAINER Marius van den Beek <marius@galaxyproject.org>

RUN yum update -y
RUN yum install -y openssh-server openssh-clients which python39
RUN mkdir -p /var/run/sshd && \
    echo "root:root" | chpasswd

RUN adduser "testuser" -m && \
    echo "testuser:testuser" | chpasswd
USER testuser
RUN mkdir /home/testuser/.ssh
ADD id_rsa.pub /home/testuser/.ssh/authorized_keys
USER root

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

RUN /bin/date

# install supervisord
RUN python3.9 -m pip install supervisor
RUN ssh-keygen -A
ADD ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub

ADD supervisord.conf /etc/supervisord.conf
EXPOSE 10389 22
CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
