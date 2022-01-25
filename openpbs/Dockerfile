######################################################
#
# Galaxy Dev OpenPBS server
# Tag: mvdbeek/galaxy-integration-docker-images:torque-22.01
#
# This container provides a standard pbs controller
# and worker created on top of the agaveapi/centos-base
# image. Nothing special here.
#
# Usage:
# docker run -h docker -i -rm             \
#            -p 10022:22                  \ # SSHD, SFTP
#            -p 9618:9618                 \ # PBS
#            --privileged
#            agaveapi/torque
#
# https://github.com/mvdbeek/galaxy-integration-docker-images
#
######################################################

FROM mvdbeek/centos-base

MAINTAINER Marius van den Beek <marius@galaxyproject.org>

# Install openPBS
RUN dnf install -y libX11 python3 hwloc libXft postgresql-contrib postgresql-server tcl tk smtpdaemon libical libICE libSM compat-hwloc1 unzip

WORKDIR /usr/local

# Pull openPBS
RUN curl -L -o openpbs.zip https://github.com/openpbs/openpbs/releases/download/v20.0.1/openpbs_20.0.1.centos_8.zip
RUN unzip openpbs.zip
WORKDIR /usr/local/openpbs_20.0.1.centos_8/
RUN rpm -Uvh --nodeps openpbs-client-20.0.1-0.x86_64.rpm openpbs-execution-20.0.1-0.x86_64.rpm openpbs-server-20.0.1-0.x86_64.rpm

# Add entrypoint script to set the current hostname so the scheduler can communicat
ADD docker_entrypoint.sh /docker_entrypoint.sh

ENTRYPOINT [ "/docker_entrypoint.sh" ]
EXPOSE 10389 22 9618
CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
