FROM ubuntu:22.04

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

WORKDIR /HyperVision
COPY ./env/install_all.sh ./env/install_all.sh
RUN chmod +x ./env/install_all.sh
RUN bash ./env/install_all.sh

WORKDIR /HyperVision/env
COPY ./env/install_z3.sh install_z3.sh
RUN chmod +x install_z3.sh
RUN ./install_z3.sh

COPY ./env/install_pcapp.sh install_pcapp.sh
RUN chmod +x install_pcapp.sh
RUN ./install_pcapp.sh

WORKDIR /HyperVision
COPY . .
RUN chmod +x ./script/rebuild.sh
RUN ./script/rebuild.sh

CMD [ "bash" ]

