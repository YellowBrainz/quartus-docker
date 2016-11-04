FROM ubuntu:latest
MAINTAINER Toon Leijtens <toonleijtens@yellowbrainz.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LICENSE Quartus-prime-megacore

# minimal number of layers
RUN apt-get update && \
    apt-get -y -qq install apt-utils \
                           software-properties-common \
                           libglib2.0-0:amd64 \
                           libpng12-0:amd64 \
                           libfreetype6:amd64 \
                           libsm6:amd64 \
                           libxrender1:amd64 \
                           libfontconfig1:amd64 \
                           libxext6:amd64 \
                           wget:amd64 &&\
    wget --quiet http://192.168.99.1/quartus/QuartusLiteSetup-16.0.0.211-linux.run -O /QuartusLiteSetup-16.0.0.211-linux.run &&\
    wget --quiet http://192.168.99.1/quartus/cyclonev-16.0.0.211.qdz -O /cyclonev-16.0.0.211.qdz &&\
    chmod 755 /QuartusLiteSetup-16.0.0.211-linux.run && \
    locale-gen en_US.UTF-8 && \
    /QuartusLiteSetup-16.0.0.211-linux.run --mode unattended --unattendedmodeui none --installdir /opt/altera_lite && \
    rm -f /QuartusLiteSetup-16.0.0.211-linux.run && \
    rm -f /cyclonev-16.0.0.211.qdz

# Install the usb device and utils
RUN apt-get -y -qq install udev && apt-get -y -qq install usbutils

# Install missing 32bit libs
RUN apt-get update && apt-get -y -qq install lib32stdc++6 libxtst6 libxi6 libgconf-2-4

# This will put the USB rules so that the Altera board is recognized
COPY /artifacts/51-usbblaster.rules /lib/udev/rules.d

# Nicing up the environment
ENV PATH $PATH:/opt/altera_lite/quartus/bin

# Start the Quartus application in an xterm
CMD ["quartus","-no_splash"]
