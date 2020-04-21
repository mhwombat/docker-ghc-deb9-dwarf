#
# To build this docker image:
#
#     docker build -t mhwombat/data-mining:0.1-ghc-deb9-dwarf .
#
FROM debian:stretch
MAINTAINER amy@nualeargais.ie

ENV GHC_VER 8.10.1
# ENV CABAL_VER 3.2.0.0

# Some commands are combined with && so we don't cache
# intermediate results.

#
# Install:
#   bootstrap version of the Haskell platform.
#   packages needed to build GHC with DWARF support
#   useful utilities for development.
#
RUN apt-get update && apt-get --assume-yes install \
            apt-utils \
            autoconf \
            build-essential \
            curl \
            gcc \
            gdb \
            git \
	    # haskell-platform \
            less \
            libdw-dev \
	    libffi-dev \
            libgmp-dev \
            libncurses-dev \
	    libtinfo5 \
            make \
            nano \
            python3 \
            realpath \
            tree \
	    unzip \
            wget \
            xz-utils

#
# Create a research user
#
RUN groupadd --system research && \
            useradd --no-log-init --system \
	        --gid research \
	        --home-dir /experiment \
		--create-home research

RUN cabal update


#
# Install ghc with DWARF support
#
WORKDIR /temp-build
RUN wget https://downloads.haskell.org/~ghc/${GHC_VER}/ghc-${GHC_VER}-x86_64-deb9-linux-dwarf.tar.xz
RUN tar xvf ghc-${GHC_VER}-x86_64-deb9-linux-dwarf.tar.xz

WORKDIR /temp-build/ghc-${GHC_VER}
RUN mkdir /usr/local/ghc-${GHC_VER}
RUN ./configure --prefix=/usr/local/ghc-${GHC_VER}
RUN make install
ENV PATH="/usr/local/ghc-${GHC_VER}/bin:${PATH}"

# WORKDIR /temp-build
# RUN wget https://downloads.haskell.org/~cabal/Cabal-${CABAL_VER}/Cabal-${CABAL_VER}.tar.gz
# RUN tar xvf Cabal-${CABAL_VER}.tar.gz

# WORKDIR /temp-build/Cabal-${CABAL_VER}
# RUN cabal install --profiling-detail=all-functions

# WORKDIR /temp-build
# RUN wget https://downloads.haskell.org/~cabal/cabal-install-${CABAL_VER}/cabal-install-${CABAL_VER}.tar.gz
# RUN tar xvf cabal-install-${CABAL_VER}.tar.gz

# WORKDIR /temp-build/cabal-install-${CABAL_VER}
# RUN sh bootstrap.sh

