FROM ubuntu:18.04

LABEL maintainer="Hédia Tnani(hediatnani0@gmail.com)" \
      version.ubuntu="18.04"

# install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    liblist-moreutils-perl \
    libset-intervaltree-perl \
    python3.6
RUN ln -s /usr/bin/python3.6 /usr/bin/python

# necessary for Bio:DB::HTS 
RUN apt-get update && apt-get install -y \
    cpanminus \
    wget \
    zlib1g-dev \
    liblzma-dev \
    libbz2-dev \
    bioperl
RUN cd /opt \
    && wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 \
    && tar -vxjf htslib-1.9.tar.bz2 \
    && cd htslib-1.9 \
    && make \
    && make install
RUN cpanm Bio::DB::HTS
# above can be deleted once dependency on Bio::DB::HTS goes away

# install Novograph
RUN cd /opt \
    && git clone https://github.com/HediaTnani/novograph.git \
    && cd novograph/src \
    && make all

ENV PATH="/opt/novograph/src:${PATH}"
ENV PERL5LIB="/opt/novograph/scripts:${PERL5LIB}"

WORKDIR /opt/novograph/scripts

# Just add comment to see if building
