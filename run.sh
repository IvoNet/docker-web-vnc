#!/usr/bin/env bash
NAME=web-vnc
PORT=8080
if [ ! -z $1 ]; then
   EP="--entrypoint bash"
fi

killpulse() {
    pulseaudio --kill 2>/dev/null
    killall pulseaudio 2>/dev/null
    rm -rf ~/.config/pulse 2>/dev/null
    mkdir -p ~/.config/pulse 2>/dev/null
    sleep .5
}

[[ -z "$(brew ls --versions pulseaudio)" ]] && brew install pulseaudio
killpulse
pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1 --daemon 2>/dev/null

docker run                                   \
    -d                                      \
    --rm                                     \
    --name $NAME                             \
    -e AUTH=${AUTH:-false}                   \
    -e USERNAME=user                         \
    -e PASSWORD=secret                       \
    -e PUID=$(id -u $USER)                   \
    -e PGID=$(id -g $USER)                   \
    -e PULSE_SERVER=docker.for.mac.localhost \
    -v ~/.config/pulse:/config/.config/pulse \
    -v "$(pwd)/.tmp/home:/config"            \
    -p ${PORT}:32000                         \
    -p 5901:5901 \
    $EP                                      \
    ivonet/$NAME
#    -v $(pwd)/root/startapp.sh:/startapp.sh  \
#    junk/x11webui
docker logs $NAME -f
docker rm -f $NAME

killpulse
