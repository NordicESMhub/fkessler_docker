FROM debian:buster

#####EXTRA LABELS#####
LABEL autogen="no" \ 
    software="CESM" \ 
    version="2" \
    software.version="2.1.1" \ 
    about.summary="Community Earth System Model" \ 
    base_image="cesm:2.1.1--py37he9b5208_1" \
    about.home="http://www.cesm.ucar.edu/models/simpler-models/fkessler/index.html" \
    about.license="Copyright (c) 2017, University Corporation for Atmospheric Research (UCAR). All rights reserved." 
      
MAINTAINER Anne Fouilloux <annefou@geo.uio.no>

RUN apt-get update -y && apt-get install -y wget git cmake \
    build-essential gfortran gdb strace m4 python subversion

RUN wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
    && tar xf mpich-3.1.4.tar.gz \
    && cd mpich-3.1.4 \
    && ./configure --enable-fast=all,O3 \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf mpich-3.1.4 \
    && rm -f mpich-3.1.4.tar.gz \
    && ldconfig

RUN wget https://www.zlib.net/zlib-1.2.11.tar.gz \
    && tar xf zlib-1.2.11.tar.gz \
    && cd zlib-1.2.11 \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf zlib-1.2.11.tar.gz zlib-1.2.11

RUN wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz \
    && tar xf hdf5-1.10.5.tar.gz \
    && cd hdf5-1.10.5 \
    && ./configure --enable-fortran --enable-parallel --prefix=/usr \
    && make -j$(nproc) \
    && make install  \
    && cd .. \
    && rm -rf hdf5-1.10.5.tar.gz hdf5-1.10.5

RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.2.tar.gz \
    && tar xf netcdf-c-4.7.2.tar.gz \
    && cd netcdf-c-4.7.2 \
    && ./configure --enable-netcdf4 --disable-dap --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf netcdf-c-4.7.2.tar.gz netcdf-c-4.7.2

RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz \
    && tar xf netcdf-fortran-4.5.2.tar.gz \
    && cd netcdf-fortran-4.5.2 \
    && CC=mpicc CXX=mpicxx FC=mpif90  CPPFLAGS=-I/usr/include LDFLAGS=-L/usr/lib ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf netcdf-fortran-4.5.2.tar.gz netcdf-fortran-4.5.2

#USER cesm

RUN mkdir -p $HOME/.cime && \
    mkdir -p $HOME/work \
             $HOME/inputdata \
             $HOME/archive \
             $HOME/cases 

COPY config_files/* $HOME/.cime/

ENV AR=ar

RUN git clone -b release-cesm2.1.1 https://github.com/ESCOMP/CESM.git \
    && cd CESM \
    && sed -i.bak "s/'checkout'/'checkout', '--trust-server-cert', '--non-interactive'/" ./manage_externals/manic/repository_svn.py \
    && ./manage_externals/checkout_externals 

ENV CESM_PES=4

ENV USER=root

RUN sed -i -e "s/\$CESM_PES/$CESM_PES/g" $HOME/.cime/config_machines.xml && \
    cd cime/scripts && \
    ./create_newcase --case $HOME/cases/fkessler --compset FKESSLER \
    --res T31_g37 --machine espresso --run-unsupported && \
    cd $HOME/cases/fkessler                            && \
    ./case.setup && ./case.build
    
WORKDIR $HOME/cases/fkessler

COPY run_fkessler $HOME/cases/fkessler

#ENTRYPOINT ./run_fkessler

CMD ["/bin/bash"]
