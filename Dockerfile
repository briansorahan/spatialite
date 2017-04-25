FROM	golang:1.8.1-alpine
RUN	apk add --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ wget geos-dev sqlite-dev gdal-dev proj4-dev git gcc g++ coreutils make zlib-dev
RUN	wget http://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz && \
	tar xzf libspatialite-4.3.0a.tar.gz && \
	rm libspatialite-4.3.0a.tar.gz && \
	cd libspatialite-4.3.0a && \
	./configure --disable-freexl --disable-libxml2 && make && make install && \
	rm -rf /go/libspatialite-4.3.0a
RUN	mkdir -p /go/src/github.com/briansorahan/spatialite
COPY	.  /go/src/github.com/briansorahan/spatialite
RUN	cd /go/src/github.com/briansorahan/spatialite && go get -t
