FROM alpine:3.10
MAINTAINER Paul Poloskov <pavel@poloskov.net>

ENV PUID 1001
ENV PGID 1001

RUN apk add --no-cache nzbget --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
    addgroup -g ${PGID} notroot && \
    adduser -D -H -G notroot -u ${PUID} notroot && \
    mkdir /config /downloads /watch /incomplete && \
    chown notroot:notroot /config /downloads /watch /incomplete

EXPOSE 9091 51413/tcp 51413/udp

HEALTHCHECK CMD netstat -an | grep 9091 > /dev/null; if [ 0 != $? ]; then exit 1; fi;

VOLUME ["/config" "/downloads" "/watch" "/incomplete"]

USER notroot

# Mount config to /etc/nzbget.conf
ENTRYPOINT [ "/usr/bin/nzbget" ]
CMD [ "--server", \
    "--option OutputMode=log",
    "--option CreateLog=no",
    "--option ControlPassword=''", \
    "--option InterDir==/incomplete", \
    "--option TempDir=/tmp", \
    "--option NzbDir=/watch", \
    "--option DestDir=/downloads"]

