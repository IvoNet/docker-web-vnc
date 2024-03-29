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
    DISPLAY=:1 \
    AUTH=false

WORKDIR /opt

ENV PREFIX_DIR="/opt/guacd"

RUN apt-get update \
    && apt-get install -y -qq --no-install-recommends \
    gosu \
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
    python3-xdg \
    alsa-base \
    dbus \
    dbus-x11 \
    sudo \
    x11-xserver-utils \
    openbox \
    xfonts-base \
    xfonts-100dpi \
    xfonts-75dpi \
    libfuse2 \
    tigervnc-standalone-server \
    tomcat9 tomcat9-admin tomcat9-common tomcat9-user \
    x11-apps \
    xterm \
    && rm -Rf /var/lib/tomcat9/webapps/ROOT \
    && mkdir -p /usr/share/tomcat9/logs/ \
    && touch /usr/share/tomcat9/logs/catalina.out \
    && curl -s -L -o /var/lib/tomcat9/webapps/ROOT.war "https://downloads.apache.org/guacamole/1.5.4/binary/guacamole-1.5.4.war"  \
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
    && wget https://downloads.apache.org/guacamole/1.5.4/source/guacamole-server-1.5.4.tar.gz \
    && tar -xvf guacamole-server-1.5.4.tar.gz \
    && rm -f /opt/guacamole-server-1.5.4.tar.gz \
    && cd /opt/guacamole-server-1.5.4 \
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
    && chown -R abc:abc /config

ENV HOME=/config
COPY root/ /


WORKDIR /project
VOLUME ["/project"]
# internal web address
EXPOSE 32000
# internal vnc server address
EXPOSE 5901

