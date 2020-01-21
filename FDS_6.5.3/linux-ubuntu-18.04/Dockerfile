# Ubuntu Image
FROM ubuntu:18.04

# Install bc and libnuma1
RUN apt-get update && apt-get install -y bc libnuma1

# provide setup-file
ARG setupfile=https://github.com/firemodels/fds/releases/download/FDS6.5.3/FDS_6.5.3-SMV_6.4.4_linux64.sh

# download FDS
ADD $setupfile /root/

# set environment variables
ENV FDSBINDIR=/root/FDS/FDS6/bin
ENV PATH=$FDSBINDIR:$PATH
ENV INTEL_SHARED_LIB=$FDSBINDIR/INTELLIBS16
ENV MPIDIST_FDS=$FDSBINDIR/openmpi_64
ENV MPIDIST=$MPIDIST_FDS
ENV LD_LIBRARY_PATH=$MPIDIST/lib:$FDSBINDIR/LIB64:$INTEL_SHARED_LIB:$LD_LIBRARY_PATH

# set execution rights, run setup script, remove setup script, extract openmpi archive, remove unessential data
RUN chmod +x /root/*.sh && \
    /root/*.sh y && \
    rm /root/*.sh && \
    tar xvf /root/FDS/FDS6/bin/openmpi_*.tar.gz -C /root/FDS/FDS6/bin/ && \
    rm /root/FDS/FDS6/bin/openmpi_1*.tar.gz && \
    mv /root/FDS/FDS6/bin /root/FDS/ && \
    rm -rf /root/FDS/FDS6/* && \
    mv /root/FDS/bin /root/FDS/FDS6/

# set workdir for fds-simulation
WORKDIR /workdir