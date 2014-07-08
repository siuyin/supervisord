FROM ubuntu:14.04
MAINTAINER siuyin@beyondbroadcast.com
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
ENV HOME /root
# Avoid running upgrade.
# RUN apt-get upgrade -y
RUN apt-get install -y openssh-server supervisor



RUN mkdir -p /var/run/sshd
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 9001
CMD ["/usr/bin/supervisord"]


# Add user siuyin
RUN adduser siuyin
RUN mkdir -p /home/siuyin/.ssh
RUN mkdir -p /root/.ssh
RUN chown siuyin:siuyin /home/siuyin/.ssh
RUN chmod 0700 /home/siuyin/.ssh
ADD id_rsa.pub /home/siuyin/.ssh/authorized_keys
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown siuyin:siuyin /home/siuyin/.ssh/authorized_keys
RUN chmod 0600 /home/siuyin/.ssh/authorized_keys

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
