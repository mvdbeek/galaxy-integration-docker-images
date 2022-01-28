######################################################
#
# Agave DevOps Slurm Server
# Tag: agaveapi/slurm
#
# This container provides a standard Slurm controller
# and worker created on top of the mvdbeek/centos-base
# image. Nothing special here.
#
# Usage:
# docker run -h docker.example.com -i -t  \
#            -p 10022:22                  \ # SSHD, SFTP
#            -p 9618:9618                 \ # Slurm
#            --rm mvdbeek/galaxy-integration-docker-images:slurm-22.01
#
######################################################

FROM mvdbeek/centos-base

MAINTAINER Marius van den Beek <marius@galaxyproject.org>

# Add slurm user
RUN adduser slurm && \
    echo "slurm:slurm" | chpasswd
USER slurm
RUN mkdir /home/slurm/.ssh
ADD ssh/id_rsa.pub /home/slurm/.ssh/authorized_keys
USER root

# Install slurm
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum install -y rpm-build gcc openssl openssl-devel pam-devel numactl numactl-devel hwloc lua readline-devel ncurses-devel libibmad libibumad munge make git
RUN dnf --enablerepo=powertools install -y munge-devel

# Configure munge
RUN create-munge-key

# Install slurm
WORKDIR /usr/local
RUN git clone https://github.com/SchedMD/slurm.git
WORKDIR /usr/local/slurm
RUN git checkout tags/slurm-21-08-5-1

RUN ./configure --prefix=/usr --sysconfdir=/etc/sysconfig/slurm --with-mysql_config=/usr/local/bin
RUN make
RUN make install
RUN mkdir -p /etc/sysconfig/slurm
RUN cp etc/init.d.slurm /etc/init.d/slurmd
RUN chmod +x /etc/init.d/slurmd

RUN chown -R root:root /var/log/munge
RUN chown -R root:root /var/lib/munge
RUN chown -R root:root /var/run/munge
RUN chown -R root:root /etc/munge

RUN mkdir /var/log/slurm
RUN touch /var/log/slurm/job_completions
RUN touch /var/log/slurm/accounting
RUN chown -R slurm:slurm /var/log/slurm

RUN touch /var/spool/last_config_lite
RUN touch /var/spool/last_config_lite.new
RUN chown slurm:slurm /var/spool/last_config_lite*

RUN chown root:slurm /var/spool
RUN chmod g+w /var/spool

ADD slurm/slurm.conf /etc/sysconfig/slurm/slurm.conf
USER testuser
ADD slurm/slurm.submit /home/testuser/slurm.submit

USER root
RUN chown testuser:testuser /home/testuser/slurm.submit
ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisor
RUN chmod -R 777 /var/log/supervisor

EXPOSE 10389 22 6817 6818
CMD /usr/local/bin/supervisord
