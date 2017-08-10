FROM alpine:latest

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

ARG arch=amd64
ARG version=1.7.1

ADD https://github.com/prometheus/prometheus/releases/download/v$version/prometheus-$version.linux-$arch.tar.gz /tmp/prometheus.tar.gz

RUN cd /tmp  \
    && tar --strip-components=1 -xzf /tmp/prometheus.tar.gz  \
    && rm /tmp/prometheus.tar.gz  \
    && mv prometheus promtool   /bin/  \
    && mkdir -p /etc/prometheus        \
    && mv prometheus.yml        /etc/prometheus/prometheus.yml  \
    && mkdir -p /usr/share/prometheus  \
    && mv consoles console_libraries NOTICE LICENSE   /usr/share/prometheus/  \
    && ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/

EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "-config.file=/etc/prometheus/prometheus.yml", \
             "-storage.local.path=/prometheus", \
             "-web.console.libraries=/usr/share/prometheus/console_libraries", \
             "-web.console.templates=/usr/share/prometheus/consoles" ]
