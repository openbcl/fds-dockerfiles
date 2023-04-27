# Ubuntu Image
FROM ubuntu:18.04

# Install bc, libnuma1, libxml2, libssl and symlink filenames
RUN apt-get update && apt-get install -y bc libnuma1 libxml2 libssl1.0.0 && \
ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/libcrypto.so.10 && \
ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/libssl.so.10

# provide setup-file
ARG setupfile=https://github.com/firemodels/fds/releases/download/FDS6.5.3/FDS_6.5.3-SMV_6.4.4_linux64.sh

# download FDS
ADD $setupfile /root/

# set environment variables
ENV FDSBINDIR=/root/FDS/FDS6/bin
ENV INTEL_SHARED_LIB=$FDSBINDIR/INTELLIBS16:/usr/lib/x86_64-linux-gnu
ENV MPIDIST_FDS=$FDSBINDIR/openmpi_64
ENV MPIDIST=$MPIDIST_FDS
ENV PATH=$MPIDIST/bin:$FDSBINDIR:$PATH
ENV LD_LIBRARY_PATH=$MPIDIST/lib:$FDSBINDIR/LIB64:$INTEL_SHARED_LIB:$LD_LIBRARY_PATH

# set execution rights, run setup script, remove setup script, extract openmpi archive, remove unessential data, set execution rights
RUN chmod +x /root/*.sh && \
    /root/*.sh y && \
    rm /root/*.sh && \
    tar xvf /root/FDS/FDS6/bin/openmpi_*.tar.gz -C /root/FDS/FDS6/bin/ && \
    rm /root/FDS/FDS6/bin/openmpi_1*.tar.gz && \
    mv /root/FDS/FDS6/bin /root/FDS/ && \
    rm -rf /root/FDS/FDS6/* && \
    mv /root/FDS/bin /root/FDS/FDS6/ && \
    mkdir -p /shared/openmpi_64/share && \
    mv /root/FDS/FDS6/bin/openmpi_64/share/openmpi /shared/openmpi_64/share/openmpi

# mpiexec won't run as root without '--allow-run-as-root' parameter - let's fix it with a simple hack
RUN mv /root/FDS/FDS6/bin/openmpi_64/bin/mpiexec /root/FDS/FDS6/bin/openmpi_64/bin/mpiexec_orig && \
    echo '#!/bin/bash\nmpiexec_orig --allow-run-as-root $@' >> /root/FDS/FDS6/bin/openmpi_64/bin/mpiexec && \
    chmod 755 /root/FDS/FDS6/bin/openmpi_64/bin/mpiexec

# set workdir for fds-simulation
WORKDIR /workdir