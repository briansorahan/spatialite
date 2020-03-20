FROM golang:1.13.9-alpine3.11

ENV PROJ_VERSION=5.2.0
ENV FREEXL_VERSION=1.0.2
ENV READOSM_VERSION=1.1.0
ENV SPATIALITE_VERSION=4.3.0

RUN apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    wget geos-dev sqlite-dev gdal-dev git gcc g++ coreutils make zlib-dev \
    expat-dev libxml2-dev readline-dev

# Install proj
RUN cd /tmp \
    && wget https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz \
    && tar xzf proj-${PROJ_VERSION}.tar.gz \
    && rm proj-${PROJ_VERSION}.tar.gz \
    && cd proj-${PROJ_VERSION} \
    && ./configure && make && make install \
    && rm -rf /tmp/proj-${PROJ_VERSION}

# Install freexl
RUN cd /tmp \
    && wget http://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-${FREEXL_VERSION}.tar.gz \
    && tar xzf freexl-${FREEXL_VERSION}.tar.gz \
    && rm freexl-${FREEXL_VERSION}.tar.gz \
    && cd freexl-${FREEXL_VERSION} \
    && ./configure && make && make install \
    && rm -rf /tmp/freexl-${FREEXL_VERSION}

# Install readosm
RUN cd /tmp \
    && wget http://www.gaia-gis.it/gaia-sins/readosm-sources/readosm-${READOSM_VERSION}.tar.gz \
    && tar xzf readosm-${READOSM_VERSION}.tar.gz \
    && rm -rf readosm-${READOSM_VERSION}.tar.gz \
    && cd readosm-${READOSM_VERSION} \
    && ./configure && make && make install \
    && rm -rf /tmp/readosm-${READOSM_VERSION}

# Install libspatialite
RUN cd /tmp \
    && wget http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && tar xzf libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && rm libspatialite-${SPATIALITE_VERSION}.tar.gz \
    && cd libspatialite-${SPATIALITE_VERSION} \
    && ./configure && make && make install \
    && rm -rf /tmp/libspatialite-${SPATIALITE_VERSION}

# Install spatialite-tools
RUN cd /tmp \
    && wget http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-${SPATIALITE_VERSION}.tar.gz \
    && tar xzf spatialite-tools-${SPATIALITE_VERSION}.tar.gz \
    && rm spatialite-tools-${SPATIALITE_VERSION}.tar.gz \
    && cd spatialite-tools-${SPATIALITE_VERSION} \
    && ./configure && make && make install \
    && rm -rf /tmp/spatialite-tools-${SPATIALITE_VERSION}

# Install the spatialite go bindings
RUN  mkdir -p /go/src/github.com/briansorahan/spatialite
COPY . /go/src/github.com/briansorahan/spatialite
RUN  cd /go/src/github.com/briansorahan/spatialite && go get -t
