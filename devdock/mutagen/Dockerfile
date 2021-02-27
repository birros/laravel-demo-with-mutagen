ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION}

# install envsubst
RUN apk update && apk add --no-cache gettext

ARG MUTAGEN_VERSION
ENV MUTAGEN_VERSION ${MUTAGEN_VERSION}

# install mutagen
RUN case $(arch) in \
        x86_64) \
            export ARCH=amd64 \
            ;; \
    esac \
    && wget -O- https://github.com/mutagen-io/mutagen/releases/download/v${MUTAGEN_VERSION}/mutagen_linux_${ARCH}_v${MUTAGEN_VERSION}.tar.gz \
        | tar -xvzf - mutagen -C /usr/local/bin

COPY ./mutagen.template.yml /root/project/
COPY ./init.sh /usr/local/bin/init

RUN chmod +x /usr/local/bin/*

CMD ["/usr/local/bin/init"]
