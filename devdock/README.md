# Devdock

This folder aims to show how to use [docker][1] with [mutagen][2].

**Pros**:

1. Improve read and write access performance on **macOS**
2. Better management of file permissions in the target container

**Cons**:

1. The `vendor` and `node_modules` folders are no longer present on the host
   side which prevents the IDE from providing its usual facilities for writing
   code. In response we can use [vscode][4] and its [remote development][5]
   feature to develop directly inside the container

## Install dependencies

Clone and run the following reverse-proxy setup to expose project locally:
[docker-traefik-mkcert][3]

## Setup

```shell
$ make      # start
$ make down # stop
```

Project available here: https://laravel-demo.dev.localhost

## Remark

This folder can be outsourced if needed.

<!-- Links -->

[1]: https://github.com/docker/docker-ce
[2]: https://github.com/mutagen-io/mutagen
[3]: https://github.com/birros/docker-traefik-mkcert
[4]: https://github.com/microsoft/vscode
[5]: https://code.visualstudio.com/docs/remote/remote-overview
[6]: https://github.com/birros/vscode-deinitialize-command
