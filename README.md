# Laravel demo with mutagen

This repo aims to show how to use [docker][1] with [mutagen][2] when working on
a php project.

**Pros**:

1. Improve read and write access performance on **macOS**
2. Better management of file permissions in the target container

**Cons**:

1. The `vendor` and `node_modules` folders are no longer present on the host
   side which prevents the IDE from providing its usual facilities for writing
   code. In response we can use [vscode][4] and its [remote development][5]
   feature to develop directly inside the container

## Install dependencies (macOS)

1. This repo depends on the following reverse-proxy setup to work out of the box,
   install and run it first: [docker-traefik-mkcert][3]

2. Install mutagen
    ```shell
    $ brew install mutagen-io/mutagen/mutagen
    ```

## Optionnal dependency

To force vscode to run `make stop` when stopping `docker-compose` stack we use
this wrapper: [vscode-deinitialize-command][6]

## Setup

```shell
$ make      # start
$ make down # stop
$ mutagen daemon stop
```

Laravel available here: https://laravel-demo.dev.localhost

## Remark

All the docker's conf are in the [devdock](./devdock) folder and can be
outsourced.

<!-- Links -->

[1]: https://github.com/docker/docker-ce
[2]: https://github.com/mutagen-io/mutagen
[3]: https://github.com/birros/docker-traefik-mkcert
[4]: https://github.com/microsoft/vscode
[5]: https://code.visualstudio.com/docs/remote/remote-overview
[6]: https://github.com/birros/vscode-deinitialize-command
