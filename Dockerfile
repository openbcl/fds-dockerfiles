############################
# Download and extract FDS #
############################
FROM alpine as fds
# download
ADD https://github.com/firemodels/fds/releases/download/FDS6.7.3/FDS6.7.3_SMV6.7.10_linux64.sh /root/
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
ENV PATH=$FDSBINDIR:$impihome/mpi/intel64/bin:$impihome/mpi/intel64/libfabric/bin:$PATH
ENV FI_PROVIDER_PATH=$impihome/mpi/intel64/libfabric/lib/prov
ENV I_MPI_ROOT=$impihome/mpi
ENV MKLROOT=$impihome/mkl
ENV LD_LIBRARY_PATH=/usr/lib64:$FDSBINDIR/LIB64:$impihome/mpi/intel64/libfabric/lib:$impihome/compiler/lib/intel64_lin:$impihome/mpi/intel64/lib:$impihome/mpi/intel64/lib/release:$LD_LIBRARY_PATH
# copy binaries
COPY --from=fds /root/FDS /root/FDS
# fix wrong name of libmpifort by symlink
RUN ln -s $FDSBINDIR/INTEL/mpi/intel64/lib/libmpifort.so.12.0.0 $FDSBINDIR/INTEL/mpi/intel64/lib/libmpifort.so.12 
# set workdir for fds-simulation
WORKDIR /workdir