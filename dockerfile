FROM ubuntu:22.04

WORKDIR /HyperVision
COPY . .

RUN apt-get update && apt-get install -y \
    python3 \ 
    python3-pip \ 
    git \ 
    wget \ 
    build-essential \ 
    cmake \ 
    libboost-all-dev \ 
    libgmp-dev \ 
    libmpfr-dev \ 
    libz3-dev \ 
    sudo

RUN chmod +x install_all.sh
RUN bash install_all.sh

WORKDIR /HyperVision/env
RUN chmod +x install_z3.sh
RUN ./install_z3.sh
RUN chmod +x install_pcapp.sh
RUN ./install_pcapp.sh






