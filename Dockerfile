############################
# Download and extract FDS #
############################
FROM alpine AS fds
# download
ADD https://github.com/firemodels/fds/releases/download/FDS-6.10.1/FDS-6.10.1_SMV-6.10.1_lnx.sh /root/
# install dependencies
RUN apk add --no-cache bash
# extract
RUN chmod +x /root/*.sh && \
    /root/*.sh y && \
    rm /root/*.sh && \
    mv /root/FDS/FDS*/bin/* /root/FDS/ && \
    find /root/FDS/* -type d -name "FDS*" -exec rm -rf {} + && \
    rm /root/FDS/*VARS.sh

#####################
# Copy FDS binaries #
#####################
FROM ubuntu:24.04
# set environment variables
ENV FDSBINDIR=/root/FDS
ENV impihome=$FDSBINDIR/INTEL
ENV PATH=$FDSBINDIR:$impihome/bin:$PATH
ENV FI_PROVIDER_PATH=$impihome/prov
ENV LD_LIBRARY_PATH=/usr/lib64:$impihome/lib:$LD_LIBRARY_PATH
# copy binaries
COPY --from=fds /root/FDS /root/FDS
# set workdir for fds-simulation
WORKDIR /workdir