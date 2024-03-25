# rclex_docker

This repository maintains the Dockerfile for the trial and tests of [Rclex](https://github.com/rclex/rclex). The pre-built images are published on our Docker Hub.

https://hub.docker.com/r/rclex/rclex_docker

You can use the Docker image like the following.

```
$ docker pull rclex/rclex_docker:latest
$ docker run -it --rm --name rclex rclex/rclex_docker:latest
```

## The rule of Docker Tags

Since Rclex relies heavily on 3 components (ROS 2, Elixir and Erlang/OTP), we decided to give the Tag of Docker image a long name to clarify each version.

- `name`-ex`A.B.C`-otp`X.Y.Z`
  - `name`: The distribution of ROS 2 (e.g., humble)
  - `A.B.C`: The version of Elixir (e.g., Elixir 1.15.5)
  - `X.Y.Z`: The version of Erlang (e.g., OTP-26.0.2)

## Available versions (docker tags)

Here is the list of Tags (also see [Tags page on Docker Hub](https://hub.docker.com/r/rclex/rclex_docker/tags)) as the CI targets for Rclex.
They are associated with the ext of each Dockerfile on [GitHub repository](https://github.com/rclex/rclex_docker).

**[latest]** means the `latest` tag associated with [the recommended environment for Rclex](https://github.com/rclex/rclex#recommended-environment).
Only this tag (including past) provides multi-platform, `linux/amd64` and `linux/arm64`.

- Humble Hawksbill (**LTS rosdistro until May 2027**)
  - humble-ex1.16.2-otp26.2.2
  - humble-ex1.15.7-otp26.2.2 **[latest]**
  - humble-ex1.14.5-otp25.3.2.5
- Foxy Fitzroy (_EOL!_)
  - foxy-ex1.15.5-otp26.0.2

We highly recommend using Humble version because the previous ROS 2 distributions have already reached EOL.
In particular, we have decided to stop supporting Dashing due to compatibility with Rclex code.

### Experimental versions

The following versions are not supported yet and are used as CI targets for Rclex, but these images have been published to Docker Hub for the future.

- Iron Irwini (_STS until Nov 2024_)
  - iron-ex1.15.5-otp26.0.2

### Deprecated versions

The following versions were used in the past and are still available on Docker Hub, but are no longer used for the operation test of Rclex.

- Humble Hawksbill
  - humble-ex1.15.5-otp26.0.2 (past latest)
  - humble-ex1.13.4-otp25.0.3
  - humble-ex1.13.4-otp24.3.4.2
- Galactic Geochelone (_EOL!_)
  - galactic-ex1.15.5-otp26.0.2
  - galactic-ex1.13.4-otp25.0.3
  - galactic-ex1.13.1-otp24.1.7
  - galactic-ex1.12.3-otp24.1.5
  - galactic-ex1.11.4-otp23.3.4
- Foxy Fitzroy (_EOL!_)
  - foxy-ex1.14.5-otp25.3.2.5
  - foxy-ex1.14.0-otp25.0.4
  - foxy-ex1.13.4-otp25.0.3
  - foxy-ex1.13.1-otp24.1.7
  - foxy-ex1.12.3-otp24.1.5
  - foxy-ex1.11.4-otp23.3.4
- Dashing Diademata (_EOL!_)
  - dashing-ex1.12.3-otp24.1.5
  - dashing-ex1.11.4-otp23.3.4
  - dashing-ex1.10.4-otp23.3.4
  - dashing-ex1.9.4-otp22.3.4.18

## Note for developers: how to use this repository

### Available commands

* `mix rclex_docker.build [options]`: Builds rclex docker images
  * `--dry-run` - show all raw docker commands which invoked by this task.
  * `--latest` - build only latest target.
  * `--multi` - build latest target for multi-platform.
* `mix rclex_docker.push [options]`: Pushes rclex docker images
  * `--dry-run` - show all raw docker commands which invoked by this task.
  * `--latest` - push only latest target.
  * `--multi` - push latest target for multi-platform.

When using `--multi` option, you need to create a builder first (e.g., `docker buildx create --use --name rclex_builder`).
And also, we guess that QEMU may be at least v5 (see [detail](https://askubuntu.com/a/1369504)).

### Modification of versions

Edit `list_target_tuples()` in lib/rclex_docker.ex
