############################
# Download and extract FDS #
############################
FROM alpine as fds
# install dependencies
RUN apk add --no-cache bash wget
# download and extract FDS
RUN wget -q https://github.com/firemodels/fds/releases/download/Git/FDS_6.2.0-SMV_6.2.2_linux64.sh -P /root && \
    chmod +x /root/*.sh && \
    /root/*.sh y && \
    rm /root/*.sh && \
    mv /root/FDS/FDS6/bin/* /root/FDS/ && \
    rm -rf /root/FDS/FDS6 && \
    rm /root/FDS/sm* && \
    rm /root/FDS/*.html && \
    rm -rf /root/FDS/textures
# download and extract openmpi from FDS 6.5.3
RUN cd /tmp && \
    wget -q https://github.com/firemodels/fds/releases/download/FDS6.5.3/FDS_6.5.3-SMV_6.4.4_linux64.sh && \
    tail -n +$(awk '/^__TARFILE_FOLLOWS__/ { print NR + 1; exit 0; }' /tmp/*.sh) *.sh | tar -xz && \
    tar xf /tmp/bin/openmpi_*.tar.gz -C /root/FDS && \
    mv /tmp/bin/LIB64/libibverbs.so.1 /root/FDS/LIB64/ && \
    rm -rf /tmp/*

#####################
# Copy FDS binaries #
#####################
FROM ubuntu:24.04
# set environment variables
ENV FDSBINDIR=/usr/bin
ENV INTEL_SHARED_LIB=/usr/lib/x86_64-linux-gnu
ENV MPIDIST_FDS=$FDSBINDIR/openmpi_64
ENV MPIDIST=$MPIDIST_FDS
ENV PATH=$MPIDIST/bin:$FDSBINDIR:$PATH
ENV LD_LIBRARY_PATH=$MPIDIST/lib:$FDSBINDIR/LIB64:$INTEL_SHARED_LIB:$LD_LIBRARY_PATH
# copy binaries
COPY --from=fds /root/FDS /usr/bin/
# Install dependencies and symlink crypto and ssl libraries
RUN apt-get update && apt-get install -y libnuma1 libxml2 adduser sudo && \
ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.3 /usr/lib/x86_64-linux-gnu/libcrypto.so.10 && \
ln -s /usr/lib/x86_64-linux-gnu/libssl.so.3 /usr/lib/x86_64-linux-gnu/libssl.so.10
# add mpi user
RUN adduser --system --no-create-home mpi
# login as mpi user
USER mpi
# set workdir for fds-simulation
WORKDIR /workdir