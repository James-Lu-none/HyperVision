FROM ubuntu:22.04 AS build_z3

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-setuptools \
    git wget unzip build-essential cmake

WORKDIR /build
RUN wget https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.11.0.zip && \
    unzip z3-4.11.0.zip && \
    mv z3-z3-4.11.0 z3

WORKDIR /build/z3
# Specify installation prefix to install Z3 libraries and headers to /usr/local
RUN python3 scripts/mk_make.py --prefix=/usr/local

WORKDIR /build/z3/build
RUN make -j"$(nproc)"
RUN make install

FROM ubuntu:22.04 AS build_pcap

RUN apt-get update && apt-get install -y \
    git wget build-essential cmake libpcap-dev \
    libgmp-dev libmpfr-dev libboost-all-dev \
    ninja-build pkg-config
# PcapPlusPlus has no binary release for aarch64(arm64) in v21.11, so build from source
WORKDIR /build
RUN git clone --branch v21.11 https://github.com/seladb/PcapPlusPlus.git

WORKDIR /build/PcapPlusPlus
RUN ./configure-linux.sh --default
RUN make -j"$(nproc)"
RUN make install

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3 python3-pip git wget cmake ninja-build 

RUN apt-get install -y \
    libpcap0.8 \
    libboost-system-dev \
    libboost-filesystem-dev \
    libgmp-dev \
    libmpfr-dev \
    libpcap-dev \
    libmlpack-dev mlpack-bin libarmadillo-dev \
    libgflags-dev

RUN pip3 install matplotlib scikit-learn

COPY --from=build_z3 /usr/local/lib /usr/local/lib
COPY --from=build_z3 /usr/local/include /usr/local/include
COPY --from=build_pcap /usr/local/lib /usr/local/lib
COPY --from=build_pcap /usr/local/include /usr/local/include

RUN ldconfig

WORKDIR /HyperVision
COPY . .

RUN wget https://github.com/nlohmann/json/releases/download/v3.10.5/json.hpp
RUN chmod +x script/rebuild.sh && ./script/rebuild.sh

RUN chmod +x /HyperVision/build/HyperVision

WORKDIR /HyperVision/build
ENTRYPOINT ["/bin/sh"]
# ENTRYPOINT ["./HyperVision"]
# CMD ["--help"]
