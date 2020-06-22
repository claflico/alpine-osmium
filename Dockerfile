FROM alpine:3.12

ENV LIBOSMIUM_VERSION=2.15.5 \
    OSMIUM_TOOL_VERSION=1.12.0 \
    PROTOZERO_VERSION=1.7.0

WORKDIR /app

RUN set -ex && \
    apk update && apk --no-cache upgrade && \
    apk add --no-cache --virtual .fetch-deps curl git && \
    apk add --no-cache --virtual .build-deps boost-dev build-base bzip2-dev cmake expat-dev libxml2-dev sparsehash zlib-dev && \
    apk add --no-cache --virtual .build-deps-testing gdal-dev geos-dev proj-dev && \
    curl -s -L https://github.com/mapbox/protozero/archive/v${PROTOZERO_VERSION}.tar.gz  -o protozero.tar.gz && \
    tar -xzvf protozero.tar.gz && rm -rf protozero.tar.gz && mv protozero-* protozero && \
    cd protozero && mkdir build && cd build && \
    cmake .. && make && \
    cd /app && curl -s -L https://github.com/osmcode/libosmium/archive/v${LIBOSMIUM_VERSION}.tar.gz  -o libosmium.tar.gz && \
    tar -xzvf libosmium.tar.gz && rm -rf libosmium.tar.gz && mv libosmium-* libosmium && \
    cd libosmium && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_EXAMPLES=OFF .. && make && \
    cd /app && curl -s -L https://github.com/osmcode/osmium-tool/archive/v${OSMIUM_TOOL_VERSION}.tar.gz  -o osmium-tool.tar.gz && \
    tar -xzvf osmium-tool.tar.gz && rm -rf osmium-tool.tar.gz && mv osmium-tool-* osmium-tool && \
    cd osmium-tool && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=MinSizeRel .. && make && make install && \
    rm -rf /app/* && \
    apk del .fetch-deps .build-deps .build-deps-testing && \
    apk add --update --no-cache boost && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["osmium"]

CMD ["--help"]
