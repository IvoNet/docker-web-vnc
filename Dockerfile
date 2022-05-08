ARG VERSION=22.04
FROM ivonet/ubuntu-s6:${VERSION}

LABEL maintainer="Ivo Woltring - @ivonet"

ENV DISPLAY=:1 \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    PYTHONDONTWRITEBYTECODE=1 \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TERM="xterm" \
    GUACD_DIR=/opt/guacd \
    LD_LIBRARY_PATH=/opt/guacd/lib \
    DISPLAY=:1

WORKDIR /opt

ENV PREFIX_DIR="/opt/guacd"

RUN apt-get update \
    && apt-get install -y -qq --no-install-recommends \
    libcairo2-dev \
    libjpeg-turbo8-dev \
    libpng-dev \
    libtool-bin \
    libossp-uuid-dev \
    libvncserver-dev \
    freerdp2-dev \
    libssh2-1-dev \
    libtelnet-dev \
    libwebsockets-dev \
    libpulse-dev \
    libvorbis-dev \
    libwebp-dev \
    libssl-dev \
    libpango1.0-dev \
    libswscale-dev \
    libavcodec-dev \
    libavutil-dev \
    libavformat-dev \
    pulseaudio \
    alsa-base \
    dbus \
    dbus-x11 \
    x11-xserver-utils \
    openbox \
    xfonts-base \
    xfonts-100dpi \
    xfonts-75dpi \
    libfuse2 \
    tigervnc-standalone-server \
    tomcat9 tomcat9-admin tomcat9-common tomcat9-user \
    x11-apps \
    && rm -Rf /var/lib/tomcat9/webapps/ROOT \
    && mkdir -p /usr/share/tomcat9/logs/ \
    && touch /usr/share/tomcat9/logs/catalina.out \
    && curl -s -L -o /var/lib/tomcat9/webapps/ROOT.war "https://downloads.apache.org/guacamole/1.4.0/binary/guacamole-1.4.0.war"  \
    && mkdir -p /etc/guacamole/lib/ \
    && mkdir -p /etc/guacamole/disabled/ \
    && mkdir -p /etc/guacamole/extensions/ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/apt/sources.list.d/temp.list /tmp/*

RUN apt-get update \
    && apt-get install -y -qq --no-install-recommends \
    build-essential \
    dirmngr \
    gnupg \
    gpg \
    && wget https://downloads.apache.org/guacamole/1.4.0/source/guacamole-server-1.4.0.tar.gz \
    && tar -xvf guacamole-server-1.4.0.tar.gz \
    && rm -f /opt/guacamole-server-1.4.0.tar.gz \
    && cd /opt/guacamole-server-1.4.0 \
    && CFLAGS=-Wno-error ./configure --with-init-dir=/etc/init.d --enable-allow-freerdp-snapshots \
    && make \
    && make install \
    && ldconfig \
    && apt-get purge -y --auto-remove unzip gpg build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/apt/sources.list.d/temp.list /tmp/*

RUN chmod +x /etc/cont-init.d/* \
    && echo "abc:abc" | chpasswd \
    && echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir /config \
    && chown -R abc:abc /config \
    && gosu abc mkdir -p "/config/.config/openbox" \
    && gosu abc mkdir -p "/config/.cache/openbox/sessions" \
    && gosu abc touch /config/.Xauthority \
    && gosu abc mkdir -p /config/.vnc


# Prebuild guacamole server binaries and libs
#COPY --from=ivonet/guacd:1.4.0 /opt/guacd /opt/guacd
COPY root/ /

EXPOSE 32000

