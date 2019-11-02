FROM quay.io/biocontainers/cesm:2.1.1--py37he9b5208_1

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

RUN ln -s /usr/local/bin/x86_64-conda_cos6-linux-gnu-ar /usr/local/bin/ar

RUN adduser -D cesm -G users

USER cesm

RUN mkdir -p /home/cesm/.cime && \
    mkdir -p /home/cesm/work \
             /home/cesm/inputdata \
             /home/cesm/archive \
             /home/cesm/cases 

COPY config_files/* /home/cesm/.cime/

ENV AR=ar

ENV USER=cesm

ENV CESM_PES=4

RUN sed -i -e "s/\$CESM_PES/$CESM_PES/g" /home/cesm/.cime/config_machines.xml && \
    create_newcase --case /home/cesm/cases/fkessler --compset FKESSLER \
    --res T31_g37 --compset FKESSLER --machine espresso --run-unsupported && \
    cd /home/cesm/cases/fkessler                                          && \
    ./case.setup && ./case.build
    
WORKDIR /home/cesm/cases/fkessler

COPY run_fkessler /home/cesm/cases/fkessler

ENTRYPOINT ./run_fkessler
