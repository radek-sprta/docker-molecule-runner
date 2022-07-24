# syntax=docker/dockerfile:1.4
ARG VERSION=latest
FROM alpine:$VERSION

LABEL maintainer="Radek Sprta <mail@radeksprta.eu>"
LABEL org.opencontainers.image.authors="Radek Sprta <mail@radeksprta.eu>"
LABEL org.opencontainers.image.description="Image to run Molecule tests for Ansible."
LABEL org.opencontainers.image.documentation="https://gitlab.com/radek-sprta/docker-molecule-runner/-/blob/master/README.md"
LABEL org.opencontainers.image.licenses="GNU General Public License v3"
LABEL org.opencontainers.image.source="https://gitlab.com/radek-sprta/docker-molecule-runner"
LABEL org.opencontainers.image.title="rsprta/molecule-runner"
LABEL org.opencontainers.image.url="https://gitlab.com/radek-sprta/docker-molecule-runner"

# Install dependencies.
RUN apk --no-cache add \
       ansible \
       ansible-lint \
       docker \
       git \
       podman \
       py3-pip \
       python3 \
       yamllint \
    && rm -Rf /var/cache/apk/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man

COPY --link requirements.txt /tmp/requirements.txt

# Install Ansible via pip.
RUN apk --no-cache add --virtual .build-dependencies \
       build-base \
       libxml2-dev \
       libxslt-dev \
       linux-headers \
       python3-dev \
    && pip3 install -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt \
    && apk del .build-dependencies

ENV SHELL /bin/sh
ENV PYTHONDONTWRITEBYTECODE=1
ENV ANSIBLE_FORCE_COLOR=1
