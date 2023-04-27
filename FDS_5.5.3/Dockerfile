# Ubuntu Image
FROM ubuntu:18.04

# Install lam mpi
RUN apt-get update && apt-get install -y lam-runtime

# provide setup-file
ARG setupfile=https://github.com/firemodels/fds/releases/download/Git/FDS_5.5.3-SMV_5.6_linux_64.tar.gz

# download FDS
ADD $setupfile /root/

# set environment variables
ENV LAMHELPDIR=/etc/lam/
ENV PATH=/home/lam/FDS/FDS5/bin:$PATH

# add nonroot user for lam mpi, extract fds archive, remove unessential data, move folders and rename files, create lamboot-starter-script, set execution rights
RUN useradd -m lam && \
    tar xvf /root/*.tar.gz -C /root/ && \
    rm /root/*.tar.gz && \
    mv /root/FDS/FDS5/bin/fds5_linux_64 /root/FDS/FDS5/bin/fds && \
    mv /root/FDS/FDS5/bin/fds5_mpi_linux_64 /root/FDS/FDS5/bin/fds_mpi && \
    mv /usr/bin/lamboot /usr/bin/lamboot_orig && \
    echo '#!/bin/bash\nlamboot_orig\n$@' >> /root/FDS/FDS5/bin/lamboot && \
    chmod 755 /root/FDS/FDS5/bin/lamboot && \
    mv /root/FDS /home/lam/ && \
    chown -R lam: /home/lam/FDS

# login as lam user
USER lam

# set workdir for fds-simulation
WORKDIR /workdir
