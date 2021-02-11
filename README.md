# Laravel demo with mutagen

This repo aims to show how to use [docker][1] with [mutagen][2] to improve read
and write access performance on **macOS** when working on a php project.

## Install dependencies (macOS)

1. This repo depends on the following reverse-proxy setup to work out of the box,
   install and run it first: [docker-traefik-mkcert][3]

2. Install mutagen
    ```shell
    $ brew install mutagen-io/mutagen/mutagen-beta
    ```
    _Tested with v0.12.0-beta2 which integrates a docker-compose replacement_

## Setup

```shell
$ make      # start
$ make down # stop
$ mutagen daemon stop
```

Laravel available here: https://laravel-demo.dev.localhost

<!-- Links -->

[1]: https://github.com/docker/docker-ce
[2]: https://github.com/mutagen-io/mutagen
[3]: https://github.com/birros/docker-traefik-mkcert
