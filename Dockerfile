FROM	golang:1.11.2-alpine

ENV     FREEXL_VERSION=1.0.5
ENV     READOSM_VERSION=1.1.0
ENV     LIBSPATIALITE_VERSION=4.3.0a
ENV     SPATIALITE_TOOLS_VERSION=4.3.0

RUN	apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/main --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ wget geos-dev sqlite-dev gdal-dev proj4-dev git gcc g++ coreutils make zlib-dev expat-dev libxml2-dev readline-dev
RUN	wget http://www.gaia-gis.it/gaia-sins/freexl-${FREEXL_VERSION}.tar.gz && \
	tar xzf freexl-${FREEXL_VERSION}.tar.gz && rm freexl-${FREEXL_VERSION}.tar.gz && cd freexl-${FREEXL_VERSION} && ./configure && make && make install && rm -rf /go/freexl-${FREEXL_VERSION}
RUN	wget http://www.gaia-gis.it/gaia-sins/readosm-${READOSM_VERSION}.tar.gz && tar xzf readosm-${READOSM_VERSION}.tar.gz && \
	rm -rf readosm-${READOSM_VERSION}.tar.gz && cd readosm-${READOSM_VERSION} && ./configure && make && make install && rm -rf /go/readosm-${READOSM_VERSION}
RUN	wget http://www.gaia-gis.it/gaia-sins/libspatialite-${LIBSPATIALITE_VERSION}.tar.gz && tar xzf libspatialite-${LIBSPATIALITE_VERSION}.tar.gz && \
	rm libspatialite-${LIBSPATIALITE_VERSION}.tar.gz && cd libspatialite-${LIBSPATIALITE_VERSION} && ./configure && make && make install && rm -rf /go/libspatialite-${LIBSPATIALITE_VERSION}
RUN	wget http://www.gaia-gis.it/gaia-sins/spatialite-tools-${SPATIALITE_TOOLS_VERSION}.tar.gz && tar xzf spatialite-tools-${SPATIALITE_TOOLS_VERSION}.tar.gz && \
	rm spatialite-tools-${SPATIALITE_TOOLS_VERSION}.tar.gz && cd spatialite-tools-${SPATIALITE_TOOLS_VERSION} && ./configure && make && make install && rm -rf /go/spatialite-tools-${SPATIALITE_TOOLS_VERSION}
RUN	mkdir -p /go/src/github.com/briansorahan/spatialite
COPY	.  /go/src/github.com/briansorahan/spatialite
RUN	cd /go/src/github.com/briansorahan/spatialite && go get -t
