FROM ubuntu:22.04 AS build_z3

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-setuptools \
    git wget unzip build-essential cmake

WORKDIR /build
RUN wget https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.11.0.zip && \
    unzip z3-4.11.0.zip && \
    mv z3-z3-4.11.0 z3

WORKDIR /build/z3
RUN python3 scripts/mk_make.py

WORKDIR /build/z3/build
RUN make -j"$(nproc)"
RUN make install

FROM ubuntu:22.04 AS build_pcap

RUN apt-get update && apt-get install -y \
    git wget build-essential cmake libpcap-dev \
    libgmp-dev libmpfr-dev libboost-all-dev \
    ninja-build pkg-config

WORKDIR /build
RUN git clone --branch v21.11 https://github.com/seladb/PcapPlusPlus.git

WORKDIR /build/PcapPlusPlus
RUN ./configure-linux.sh --default
RUN make -j"$(nproc)"
RUN make install

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libpcap0.8 \
    libboost-system-dev \
    libboost-filesystem-dev \
    libgmp-dev \
    libmpfr-dev \
    python3 python3-pip git wget cmake

COPY --from=build_z3 /usr/local/lib /usr/local/lib
COPY --from=build_z3 /usr/local/include /usr/local/include
COPY --from=build_pcap /usr/local/lib /usr/local/lib
COPY --from=build_pcap /usr/local/include /usr/local/include

RUN ldconfig

WORKDIR /HyperVision
COPY . .

RUN chmod +x script/rebuild.sh && ./script/rebuild.sh

CMD ["/bin/bash"]
