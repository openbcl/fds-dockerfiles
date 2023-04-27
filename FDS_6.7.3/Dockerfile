# Ubuntu Image
FROM ubuntu:18.04

# provide setup-file
ARG setupfile=https://github.com/firemodels/fds/releases/download/FDS6.7.3/FDS6.7.3_SMV6.7.10_linux64.sh

# download FDS
ADD $setupfile /root/

# set environment variables
ENV FDSBINDIR=/root/FDS/FDS6/bin
ENV impihome=/root/FDS/FDS6/bin/INTEL
ENV PATH=$FDSBINDIR:$impihome/mpi/intel64/bin:$impihome/mpi/intel64/libfabric/bin:$PATH
ENV FI_PROVIDER_PATH=$impihome/mpi/intel64/libfabric/lib/prov
ENV I_MPI_ROOT=$impihome/mpi
ENV MKLROOT=$impihome/mkl
ENV LD_LIBRARY_PATH=/usr/lib64:$FDSBINDIR/LIB64:$impihome/mpi/intel64/libfabric/lib:$impihome/compiler/lib/intel64_lin:$impihome/mpi/intel64/lib:$impihome/mpi/intel64/lib/release:$LD_LIBRARY_PATH

# set execution rights, run setup script, remove setup script and unessential data, fix wrong name of libmpifort by symlink
RUN chmod +x /root/*.sh && \
    /root/*.sh y && \
    rm /root/*.sh && \
    mv /root/FDS/FDS6/bin /root/FDS/ && \
    rm -rf /root/FDS/FDS6/* && \
    mv /root/FDS/bin /root/FDS/FDS6/ && \
    ln -s /root/FDS/FDS6/bin/INTEL/mpi/intel64/lib/libmpifort.so.12.0.0 /root/FDS/FDS6/bin/INTEL/mpi/intel64/lib/libmpifort.so.12 

# set workdir for fds-simulation
WORKDIR /workdir