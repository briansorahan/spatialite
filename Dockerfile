FROM	golang:1.8.1-alpine
RUN	apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ wget geos-dev sqlite-dev gdal-dev proj4-dev git gcc g++ coreutils make zlib-dev expat-dev libxml2-dev
RUN	wget http://www.gaia-gis.it/gaia-sins/freexl-1.0.2.tar.gz && \
	tar xzf freexl-1.0.2.tar.gz && rm freexl-1.0.2.tar.gz && cd freexl-1.0.2 && ./configure && make && make install && rm -rf /go/freexl-1.0.2
RUN	wget http://www.gaia-gis.it/gaia-sins/readosm-1.0.0e.tar.gz && tar xzf readosm-1.0.0e.tar.gz && \
	rm -rf readosm-1.0.0e.tar.gz && cd readosm-1.0.0e && ./configure && make && make install && rm -rf /go/readosm-1.0.0e
RUN	wget http://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz && tar xzf libspatialite-4.3.0a.tar.gz && \
	rm libspatialite-4.3.0a.tar.gz && cd libspatialite-4.3.0a && ./configure && make && make install && rm -rf /go/libspatialite-4.3.0a
RUN	wget http://www.gaia-gis.it/gaia-sins/spatialite-tools-4.3.0.tar.gz && tar xzf spatialite-tools-4.3.0.tar.gz && \
	rm spatialite-tools-4.3.0.tar.gz && cd spatialite-tools-4.3.0 && ./configure && make && make install && rm -rf /go/spatialite-tools-4.3.0
RUN	mkdir -p /go/src/github.com/briansorahan/spatialite
COPY	.  /go/src/github.com/briansorahan/spatialite
RUN	cd /go/src/github.com/briansorahan/spatialite && go get -t
