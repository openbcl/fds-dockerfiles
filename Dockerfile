############################
# Download and extract FDS #
############################
FROM alpine as fds
# download
ADD https://github.com/firemodels/fds/releases/download/Git/FDS_5.5.3-SMV_5.6_linux_64.tar.gz /root/
# extract
RUN tar xvf /root/*.tar.gz -C /root/ && \
    rm /root/*.tar.gz && \
    mv /root/FDS/FDS5/bin/fds5_linux_64 /root/FDS/FDS5/bin/fds && \
    mv /root/FDS/FDS5/bin/fds5_mpi_linux_64 /root/FDS/FDS5/bin/fds_mpi

############################
# Download and extract FDS #
############################
FROM ubuntu:18.04
# set environment variables
ENV LAMHELPDIR=/etc/lam/
ENV PATH=/home/lam/FDS/FDS5/bin:$PATH
# install lam mpi and add lam user
RUN apt-get update && apt-get install -y lam-runtime && useradd -m lam
# copy binaries
COPY --from=fds /root/FDS /home/lam/FDS
# configure lamboot
RUN mv /usr/bin/lamboot /usr/bin/lamboot_orig && \
    echo '#!/bin/bash\nlamboot_orig\n$@' >> /home/lam/FDS/FDS5/bin/lamboot && \
    chmod 755 /home/lam/FDS/FDS5/bin/lamboot
# login as lam user
USER lam
# set workdir for fds-simulation
WORKDIR /workdir