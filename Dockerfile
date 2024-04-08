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
    mv /root/FDS/FDS5/bin/fds5_mpi_linux_64 /root/FDS/FDS5/bin/fds_mpi && \
    rm /root/FDS/FDS5/bin/sm* && \
    rm /root/FDS/FDS5/bin/RE* && \
    rm -rf /root/FDS/FDS5/bin/textures && \
    mv /root/FDS/FDS5/bin/* /root/FDS/ && \
    rm -rf /root/FDS/FDS5 && \
    printf  '#!/bin/bash\nlamboot_orig\n$@' >> /root/FDS/lamboot && \
    chmod 755 /root/FDS/lamboot

############################
# Download and extract FDS #
############################
FROM ubuntu:22.04
# set environment variables
ENV LAMHELPDIR=/etc/lam/
# install lam mpi and add lam user
RUN apt-get update && apt-get install -y lam-runtime && adduser --system --no-create-home lam && mv /usr/bin/lamboot /usr/bin/lamboot_orig
# copy binaries
COPY --from=fds /root/FDS/* /usr/bin/
# login as lam user
USER lam
# set workdir for fds-simulation
WORKDIR /workdir