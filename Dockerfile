#
# To build this docker image:
#
#     docker build -t mhwombat/data-mining:0.1-ghc-deb9-dwarf .
#
FROM debian:stretch
MAINTAINER amy.de.buitleir@ericsson.com

# Some commands are combined with && so we don't cache
# intermediate results.

RUN apt-get update && apt-get --assume-yes install \
            gcc \
            gdb \
	    less \
	    libdw-dev \
	    make \
	    nano \
	    tree \
	    wget \
	    xz-utils

#
# Install ghc with DWARF support
#
WORKDIR temp-build
RUN wget https://downloads.haskell.org/~ghc/8.10.1/ghc-8.10.1-x86_64-deb9-linux-dwarf.tar.xz
RUN tar -xvf ghc-8.10.1-x86_64-deb9-linux-dwarf.tar.xz

WORKDIR /temp-build/ghc-8.10.1
RUN mkdir /usr/local/ghc-8.10.1
RUN ./configure --prefix=/usr/local/ghc-8.10.1
RUN make install
ENV PATH="/usr/local/ghc-8.10.1/bin:${PATH}"

WORKDIR /
RUN rm -rf temp-build

RUN groupadd --system research && \
            useradd --no-log-init --system \
	        --gid research \
	        --home-dir /experiment \
		--create-home research \
