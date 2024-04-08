############################
# Download and extract FDS #
############################
FROM alpine as fds
# download
ADD https://github.com/firemodels/fds/releases/download/FDS6.5.3/FDS_6.5.3-SMV_6.4.4_linux64.sh /root/
# install dependencies
RUN apk add --no-cache bash
# extract
RUN chmod +x /root/*.sh && \
    /root/*.sh y && \
    rm /root/*.sh && \
    tar xvf /root/FDS/FDS6/bin/openmpi_*.tar.gz -C /root/FDS/FDS6/bin/ && \
    rm /root/FDS/FDS6/bin/openmpi_1*.tar.gz && \
    mv /root/FDS/FDS6/bin/* /root/FDS/ && \
    rm -rf /root/FDS/FDS6 && \
    rm /root/FDS/sm* && \
    rm /root/FDS/*.html && \
    rm -rf /root/FDS/textures

#####################
# Copy FDS binaries #
#####################
FROM ubuntu:22.04
# set environment variables
ENV FDSBINDIR=/usr/bin
ENV INTEL_SHARED_LIB=$FDSBINDIR/INTELLIBS16:/usr/lib/x86_64-linux-gnu
ENV MPIDIST_FDS=$FDSBINDIR/openmpi_64
ENV MPIDIST=$MPIDIST_FDS
ENV PATH=$MPIDIST/bin:$FDSBINDIR:$PATH
ENV LD_LIBRARY_PATH=$MPIDIST/lib:$FDSBINDIR/LIB64:$INTEL_SHARED_LIB:$LD_LIBRARY_PATH
# copy binaries
COPY --from=fds /root/FDS /usr/bin/
# Install dependencies and symlink crypto and ssl libraries
RUN apt-get update && apt-get install -y libnuma1 libxml2 && \
    ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.3 /usr/lib/x86_64-linux-gnu/libcrypto.so.10 && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.so.3 /usr/lib/x86_64-linux-gnu/libssl.so.10
# add mpi user
RUN adduser --system --no-create-home mpi
# login as mpi user
USER mpi
# set workdir for fds-simulation
WORKDIR /workdir