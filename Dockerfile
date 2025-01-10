FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    ca-certificates \
    wget curl \
    zip unzip gzip \
    make autoconf automake pkg-config build-essential \
    zlib1g-dev libbz2-dev libltdl-dev libtool \
    libcurl4-openssl-dev \
    libxml2-dev \
    libgdal-dev \
    libssl-dev \
    default-jre-headless \
    perl \
    git \
    software-properties-common \
    dirmngr \
  && apt-get upgrade --yes \
  && apt-get clean

RUN apt-get install --no-install-recommends --yes \
  python3-dev \
  python3-pip
RUN pip install ruffus

RUN apt-get install --no-install-recommends --yes \
  locales \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

RUN apt-get install --no-install-recommends --yes \
  r-base \
  r-base-core \
  r-base-dev \
  r-recommended \
  && apt-get clean

RUN R -e 'install.packages("BiocManager")'
RUN R -e 'BiocManager::install("DESeq2", update = TRUE)'

WORKDIR /opt
ENV PATH ${PATH}:/opt/

ARG PROGRAM="Trimmomatic"
ARG VERSION="0.39"
RUN wget https://github.com/usadellab/Trimmomatic/files/5854859/Trimmomatic-${VERSION}.zip \
  -O ${PROGRAM}.zip \
  && unzip ${PROGRAM}.zip \
  && rm -rf ${PROGRAM}.zip \
  && echo '#!/bin/bash' > /opt/${PROGRAM}-${VERSION}/trimmomatic \
  && echo "java -jar ${PWD}/${PROGRAM}-${VERSION}/trimmomatic-${VERSION}.jar \${@}" >> trimmomatic \
  && chmod +x trimmomatic \
  && cp -r ${PROGRAM}-${VERSION}/adapters ./
ENV PATH ${PATH}:/opt/${PROGRAM}-${VERSION}/

ARG PROGRAM="STAR"
ARG VERSION="2.7.1a"
RUN wget https://github.com/alexdobin/${PROGRAM}/archive/${VERSION}.zip \
  -O ${PROGRAM}.zip \
  && unzip ${PROGRAM}.zip \
  && rm ${PROGRAM}.zip \
  && make -C ${PROGRAM}-${VERSION}/source STAR STARlong
ENV PATH ${PATH}:/opt/${PROGRAM}-${VERSION}/bin/Linux_x86_64

ARG PROGRAM="samtools"
ARG VERSION="1.14"
RUN wget https://github.com/samtools/samtools/releases/download/${VERSION}/${PROGRAM}-${VERSION}.tar.bz2 \
  -O ${PROGRAM}.tar.bz2 \
  && tar jxf ${PROGRAM}.tar.bz2 \
  && rm ${PROGRAM}.tar.bz2 \
  && make -C ${PROGRAM}-${VERSION} \
  && make -C ${PROGRAM}-${VERSION} install

ARG PROGRAM="salmon"
ARG VERSION="1.5.2"
RUN wget https://github.com/COMBINE-lab/${PROGRAM}/releases/download/v${VERSION}/${PROGRAM}-${VERSION}_linux_x86_64.tar.gz \
  -O ${PROGRAM}.tar.gz \
  && tar xzf ${PROGRAM}.tar.gz \
  && rm ${PROGRAM}.tar.gz
ENV PATH ${PATH}:/opt/${PROGRAM}-${VERSION}_linux_x86_64/bin/

ARG PROGRAM="gffread"
ARG VERSION="0.12.7"
RUN wget https://github.com/gpertea/${PROGRAM}/releases/download/v${VERSION}/${PROGRAM}-${VERSION}.Linux_x86_64.tar.gz \
  -O ${PROGRAM}.tar.gz \
  && tar xzf ${PROGRAM}.tar.gz \
  && rm ${PROGRAM}.tar.gz
ENV PATH ${PATH}:/opt/${PROGRAM}-${VERSION}.Linux_x86_64/

ARG PROGRAM="NGPINT"
ARG VERSION="1.0.0"
RUN wget https://github.com/Wiselab2/NGPINT/archive/refs/tags/NGPINTv${VERSION}.tar.gz \
  -O ${PROGRAM}.tar.gz \
  && tar -xzf ${PROGRAM}.tar.gz \
  && rm ${PROGRAM}.tar.gz

RUN ln -s /usr/bin/python3 /usr/bin/python

COPY ngpint ./
COPY NGPINT_V2.py ./
COPY scripts/ ./scripts/
COPY perform_DE_analysis_deseq2.R ./

ENTRYPOINT [ "python", "ngpint" ]
# CMD ["/bin/bash"]