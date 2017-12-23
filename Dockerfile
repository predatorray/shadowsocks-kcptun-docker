FROM ubuntu:xenial
LABEL maintainer "Wenhao Ji <predator.ray@gmail.com>"

# Python
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends python \
    && rm -rf /var/log/dpkg.log /var/lib/apt/lists/* /var/log/apt/*

# Supervisord
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends supervisor \
    && rm -rf /var/log/dpkg.log /var/lib/apt/lists/* /var/log/apt/*

# Python and Shadowsocks
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends python-setuptools python-pip \
    && pip install --upgrade pip \
    && pip install shadowsocks \
    && apt-get purge -y --auto-remove python-setuptools python-pip \
    && rm -rf /var/log/dpkg.log /var/lib/apt/lists/* /var/log/apt/*

# kcptun
ARG kcptun_targz_url="https://github.com/xtaci/kcptun/releases/download/v20171201/kcptun-linux-amd64-20171201.tar.gz"
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && wget --no-check-certificate "${kcptun_targz_url}" -O /tmp/kcptun.tar.gz \
    && mkdir -p /usr/local/kcptun && tar -zxf /tmp/kcptun.tar.gz -C /usr/local/kcptun \
    && rm -f /tmp/kcptun.tar.gz \
    && apt-get purge -y --auto-remove wget \
    && rm -rf /var/log/dpkg.log /var/lib/apt/lists/* /var/log/apt/*

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY shadowsocks-kcptun.supervisor.conf /etc/supervisor/conf.d/shadowsocks-kcptun.conf

ENTRYPOINT [ "/docker-entrypoint.sh" ]
