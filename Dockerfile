#via https://github.com/linuxserver/dockergui
# Builds a docker gui image
#FROM hurricane/dockergui:xvnc
FROM hurricane/dockergui:x11rdp1.3

MAINTAINER xthursdayx

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set environment variables

# User/Group ID gPodder will be executed as - default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# App Name
ENV APP_NAME="gPodder"

# Default resolution, change if you like
ENV WIDTH=1280
ENV HEIGHT=720

# gPodder database and settings files
ENV GPODDER_HOME /config

# gPodder downloads directory
ENV GPODDER_DOWNLOAD_DIR /downloads

# X11 Display
ENV DISPLAY=:1

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN \
#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list && \

# Install packages needed for app
# export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update -y && \
apt-get install -y -q \
    ca-certificates \
    dbus-x11 \
    git \
    gir1.2-gtk-3.0 \
    gir1.2-webkit2-3.0 \
    libgtk-3-dev \
    python3-dbus \
    python3-gi \
    python3-gi-cairo \
    python-html5lib \
    python-mutagen \
    --no-install-recommends

RUN \
#########################################
##          INSTALL GPODDER            ##
#########################################
apt-get install --no-install-recommends -y -q gpodder && \

# clean up
apt-get clean

# Copy gPodder start script to right location
COPY startapp.sh /startapp.sh

#########################################
##           PORTS AND VOLUMES         ##
#########################################

RUN mkdir -p /downloads

# Place whatever volumes and ports you want exposed here:
VOLUME ["/downloads", "/config"]

EXPOSE 8080 3389