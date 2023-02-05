# podmatrix

A script which executes commands within a 'matrix' of Podman containers.

One purpose would be to quickly spawn containers and launch an application
test suite within those containers, against multiple versions of a specific
programming language.

The containers are created in sequence, then commands are executed in parallel.

`podmatrix` is fast and only requires Bash and rootless Podman.

The script exit code is the sum of executed commands exit codes, which means 0
if everything went fine.

Use `echo $?` to display it after execution.

## Requirements

* [GNU bash](https://www.gnu.org/software/bash/) 4+
* [Podman](https://podman.io/)

## Install

```
wget https://raw.githubusercontent.com/jfhovinne/podmatrix/master/podmatrix && chmod +x podmatrix
```

## Usage

```
$ podmatrix
podmatrix - A script which executes commands within a 'matrix' of Podman containers

Usage:
  podmatrix COMMAND
  podmatrix [COMMAND] --help | -h
  podmatrix --version | -v

Commands:
  exec   Execute a command inside Podman containers
```

### exec command

```
$ podmatrix exec --help
podmatrix exec - Execute a command inside Podman containers

Alias: e

Usage:
  podmatrix exec COMMAND [OPTIONS]
  podmatrix exec --help | -h

Options:
  --help, -h
    Show this help

  --source, -s SOURCE
    Local source path to copy into containers

  --target, -t TARGET
    Container path to copy source to and where command will be executed

  --image, -i IMAGE (repeatable)
    The container image to run

  --tag TAG (repeatable)
    The container image tag to run
    Default: latest

Arguments:
  COMMAND
    The command to execute

Examples:
  podmatrix exec ./test.sh --source . --target /tmp/src --image python --tag 3.9
  --tag 3.10 --tag 3.11
  podmatrix exec ./test.sh --source . --target /tmp/src --image python --image
  docker.io/pypy --tag 3.8 --tag 3.9
```

## Examples

Current directory contains a Python application and a `test.sh` script which
builds and tests it.

To test it with different Python versions:

```
podmatrix exec ./test.sh --source . --target /tmp/src --image python \
--tag 3.9 --tag 3.10 --tag 3.11
```

To test it with different Python versions and flavors:

```
podmatrix exec ./test.sh --source . --target /tmp/src --image python --image
docker.io/pypy --tag 3.8 --tag 3.9
```

Test installation of a PHP package with different versions of Composer:

```
podmatrix exec "composer require monolog/monolog" --image docker.io/composer \
--tag 1.10 --tag 2.2 --tag 2.3 --tag 2.4 --tag 2.5
```

Compare installation of the curl package in Debian and Ubuntu (why not):

```
podmatrix exec "apt update && apt install -y curl" \
--image debian --image ubuntu > curl.log
```

Clone a Python app repository and install its dependencies:

```
podmatrix exec "git clone https://github.com/jfhovinne/gnrt && cd gnrt && pip install -r requirements.txt" \
--image python --tag 3.11 --tag 3.12.0a4
```
