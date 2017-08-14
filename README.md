# Prometheus on ARM

This project produces [Prometheus](https://prometheus.io) Docker images for
*ARM* hosts (and one for *x64* for testing).

The available tags are:

- `armhf`: for *32-bits ARM* hosts (built on [Travis](https://travis-ci.org/rycus86/docker-prometheus))  
  [![Layers](https://images.microbadger.com/badges/image/rycus86/prometheus:armhf.svg)](https://microbadger.com/images/rycus86/prometheus:armhf "Get your own image badge on microbadger.com")
- `aarch64`: for *64-bits ARM* hosts (also built on Travis)  
  [![Layers](https://images.microbadger.com/badges/image/rycus86/prometheus:aarch64.svg)](https://microbadger.com/images/rycus86/prometheus:aarch64 "Get your own image badge on microbadger.com")
- `latest`: for *x86* hosts (auto-built on [Docker Hub](https://hub.docker.com/r/rycus86/prometheus/)  
  [![Layers](https://images.microbadger.com/badges/image/rycus86/prometheus.svg)](https://microbadger.com/images/rycus86/prometheus "Get your own image badge on microbadger.com")

The images are all based on *Alpine Linux* with the *ARM* images having a
small *QEMU* binary to be able to build them on *x64* hosts.

## Usage

The image uses the same `ENTRYPOINT` and `CMD` instructions as the official
[prom/prometheus](https://hub.docker.com/r/prom/prometheus/) image.

To run it, use:

```shell
docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml \
       rycus86/prometheus
```

This will take your *Prometheus* config from `/tmp/prometheus.yml` and use it
to start the *x64* version on port *9090*.

To run it with __docker-compose__:

```yaml
version: '2'
services:

  prometheus:
    image: rycus86/prometheus:aarch64
    restart: always
    ports:
     - "9090:9090"
    volumes:
     - /tmp/prometheus.yml:/etc/prometheus/prometheus.yml

  ...
```

This will start the *64-bits ARM* version with the configuration as above but
because of *docker-compose* you can refer to the monitored applications with
their service name as hostname.
For example if you have a `webapp` service exposing metrics on port *9123*
you can configure it in the `prometheus.yml` file as:

```yaml
...

scrape_configs:

  - job_name: 'web_app'
    
    static_configs:
     - targets: ['webapp:9123']
  
  ...
```

