# rclex_docker

This repository maintains the Dockerfile for the trial and tests of [Rclex](https://github.com/rclex/rclex). The pre-built images are published on our Docker Hub.

https://hub.docker.com/r/rclex/rclex_docker

You can use the Docker image like the follow.

```
$ docker pull rclex/rclex_docker:latest
$ docker run -it --rm --name rclex rclex/rclex_docker:latest
```

## The rule of Docker Tags

Since Rclex relies heavily on 3 components (ROS 2, Elixir and Erlang/OTP), we decide to give the Tag of Docker image a long name to clarify each version.

- `name`-ex`A.B.C`-otp`X.Y.Z`
  - `name`: The distribution of ROS 2 (e.g., foxy)
  - `A.B.C`: The version of Elixir (e.g., Elixir 1.12.3)
  - `X.Y.Z`: The version of Erlang (e.g., OTP-24.1.5)

## Available versions (docker tags)

Here is the list of Tags (also see [Tags page on Docker Hub](https://hub.docker.com/r/rclex/rclex_docker/tags)). They are associated with the ext of each Dockerfile on [GitHub repository](https://github.com/rclex/rclex_docker).

**[latest]** means the `latest` tag and `Dockerfile` (without the ext).

- Foxy Fitzroy
  - foxy-ex1.14.0-otp25.0.4
  - foxy-ex1.13.4-otp25.0.3 **[latest]**
  - foxy-ex1.12.3-otp24.1.5
  - foxy-ex1.11.4-otp23.3.4

### Experimental versions

The following versions are not supported yet for Rclex but these images are already published to Docker Hub for the future.

- Galactic Geochelone
  - galactic-ex1.13.4-otp25.0.3
- Humble Hawksbill
  - humble-ex1.13.4-otp25.0.3

### Deprecated versions

The following versions were used in the past and are still available on Docker Hub, but are no longer used for the operation test of Rclex.
In particular, please note that we have decided to stop supporting Dashing since it has already reached EOL.

- Dashing Diademata
  - dashing-ex1.12.3-otp24.1.5
  - dashing-ex1.11.4-otp23.3.4
  - dashing-ex1.10.4-otp23.3.4
  - dashing-ex1.9.4-otp22.3.4.18
- Foxy Fitzroy
  - foxy-ex1.13.1-otp24.1.7
- Galactic Geochelone
  - galactic-ex1.13.1-otp24.1.7
  - galactic-ex1.12.3-otp24.1.5
  - galactic-ex1.11.4-otp23.3.4
- Humble Hawksbill
  - humble-ex1.13.4-otp24.3.4.2

## Note for developers: how to use this repository

### Available commands

* `mix rclex_docker.build [options]`: Builds rclex docker images
  * `--dry-run` - show all raw docker commands which invoked by this task.
  * `--latest` - build only latest target.
* `mix rclex_docker.push [options]`: Pushes rclex docker images
  * `--dry-run` - show all raw docker commands which invoked by this task.
  * `--latest` - push only latest target.

### Modification of versions

Edit `list_target_tuples()` in lib/rclex_docker.ex
