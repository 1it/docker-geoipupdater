FROM debian:stable-slim

# GeoIP Updater version
ENV VERSION 4.1.5

RUN apt-get update; apt-get install -y --no-install-recommends cron wget ca-certificates

RUN wget https://github.com/maxmind/geoipupdate/releases/download/v${VERSION}/geoipupdate_${VERSION}_linux_amd64.deb; \
    apt-get install -y ./geoipupdate_${VERSION}_linux_amd64.deb

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ADD docker-entrypoint.sh /docker-entrypoint.sh

VOLUME [ "/usr/share/GeoIP" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "/usr/sbin/cron", "-f"]
