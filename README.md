# podmatrix

A script which executes commands within a 'matrix' of Podman containers.

One purpose would be to quickly spawn containers and launch an application
test suite within those containers.

The containers are currently created then destroyed in sequence.

While many (much more advanced) alternatives exist already, one advantage of
this script is that it only requires Bash and Podman (rootless).

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

Arguments:
  COMMAND
    The command to execute

Examples:
  podmatrix exec ./test.sh --source . --target /tmp/src --image python:3.9
  --image python:3.10 --image python:3.11
```

## Examples

Current directory contains a Python application and a `test.sh` script which
builds and tests it.

To test it with different Python versions:

```
podmatrix exec ./test.sh --source . --target /tmp/src \
--image python:3.9 \
--image python:3.10 \
--image python:3.11
```

Test installation of a PHP package with different versions of Composer:

```
podmatrix exec "composer require monolog/monolog" \
--image docker.io/composer:1.10 \
--image docker.io/composer:2.2 \
--image docker.io/composer:2.3 \
--image docker.io/composer:2.4 \
--image docker.io/composer:2.5
```

Compare installation of the curl package in Debian and Ubuntu (why not):

```
podmatrix exec "apt update && apt install -y curl" --image debian --image ubuntu > curl.log
```

Clone a Python app repository and install its dependencies:

```
podmatrix exec "git clone https://github.com/jfhovinne/gnrt && cd gnrt && pip install -r requirements.txt" \
--image python:3.11 \
--image python:3.12.0a4
```
