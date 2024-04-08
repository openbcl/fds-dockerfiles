############################
# Download and extract FDS #
############################
FROM alpine as fds
# download
ADD https://github.com/firemodels/fds/releases/download/FDS6.6.0/FDS_6.6.0-SMV_6.6.0_linux64.sh /root/
# install dependencies
RUN apk add --no-cache bash
# extract
RUN chmod +x /root/*.sh && \
    /root/*.sh y && \
    rm /root/*.sh && \
    mv /root/FDS/FDS6/bin/* /root/FDS/ && \
    rm -rf /root/FDS/FDS6 && \
    rm /root/FDS/sm* && \
    rm -rf /root/FDS/textures

#####################
# Copy FDS binaries #
#####################
FROM ubuntu:22.04
# set environment variables
ENV FDSBINDIR=/root/FDS
ENV PATH=$FDSBINDIR:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64:$FDSBINDIR/LIB64:$LD_LIBRARY_PATH
# copy binaries
COPY --from=fds /root/FDS /root/FDS
# set workdir for fds-simulation
WORKDIR /workdir