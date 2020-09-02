FROM ubuntu:focal AS build-arc-theme-deps


ENV DEBIAN_FRONTEND noninteractive

# non-obvious dependencies:
#   glib-compile-resources from libglib2.0-dev-bin
#   gdk-pixbuf-pixdata from libgdk-pixbuf2.0-bin
RUN apt update \
 && apt install -y --no-install-recommends \
    autoconf \
    automake \
    inkscape \
    libglib2.0-dev-bin \
    libgdk-pixbuf2.0-bin \
    make \
    optipng \
    pkgconf \
    sassc \
 && rm -rf /var/lib/apt/lists/*



FROM build-arc-theme-deps

# allow handing in build options
# see https://github.com/jnsh/arc-theme/blob/master/INSTALL.md#build-options
ARG BUILD_OPTIONS

# copy source directory into the container
COPY . /build/src
WORKDIR /build/src

# configure, build and install inside the container
RUN ./autogen.sh --prefix=/build/artifacts $BUILD_OPTIONS
RUN make -j$(nproc) install

# copy final theme directories out of the container
VOLUME /install
RUN test -d /install && cp -r /build/artifacts/share/themes/* /install/
