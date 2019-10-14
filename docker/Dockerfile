FROM docker

# Prerequisites, mostly from compose
# gnupg for pass
# bash for nimbusapp
RUN apk add --no-cache \
        py-pip \
        python-dev \
        libffi-dev \
        openssl-dev \
        gcc \
        libc-dev \
        make \
        curl \
        bash \
        gnupg

RUN set -xe; \
    pip install docker-compose; \
    rm -rf /root/.cache/pip

# Pass
RUN set -xe; \
    mkdir /tmp/pass; \
    curl -sL "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.3.tar.xz" -o- | tar xJv -C /tmp/pass; \
    cd /tmp/pass/password-store-1.7.3; \
    make install; \
    cd; \
    rm -vr /tmp/pass;

# Credential helper
RUN set -xe; \
    curl -sL "https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz" \
        -o- | tar xzv -C /usr/local/bin; \
    chmod +x /usr/local/bin/docker-credential-pass

# Install docker-app
RUN set -xe; \
    curl -sL "https://github.com/docker/app/releases/download/v0.6.0/docker-app-linux.tar.gz" -o- | \
        tar xzv -C /tmp; \
    mv -v /tmp/docker-app-linux /usr/local/bin/docker-app; \
    chmod +x /usr/local/bin/docker-app

# Install nimbusapp
COPY nimbusapp /usr/local/bin/
RUN chmod +x /usr/local/bin/nimbusapp

# Setup
## GPG: https://www.gnupg.org/documentation/manuals/gnupg/Unattended-GPG-key-generation.html
COPY config.json /root/.docker/config.json
ENV NIMBUS_BASEDIR=/var/lib/nimbusapp

ENTRYPOINT [ "nimbusapp" ]
