# rclex_docker

This repository maintains the Dockerfile for the trial and tests of [Rclex](https://github.com/rclex/rclex). The pre-built images are published on our Docker Hub.

https://hub.docker.com/r/rclex/rclex_docker

You can use the Docker image like the follow.

```
$ docker pull rclex/rclex_docker:latest
$ docker run -it --rm --name rclex rclex/rclex_docker:latest
```

## The rule of Docker Tags and Git Branches

Since Rclex relies heavily on 3 components (ROS 2, Elixir and Erlang/OTP), we decide to give the Tag of Docker image a long name to clarify each version.

- `name`-ex`A.B.C`-otp`X.Y.Z`
  - `name`: The distribution of ROS 2 (e.g., dashing, foxy)
  - `A.B.C`: The version of Elixir (e.g., Elixir 1.9.1)
  - `X.Y.Z`: The version of Erlang (e.g., OTP-22.0.7)

The Tags of Docker image associate with the [Branches of Git/GitHub](https://github.com/rclex/rclex_docker/branches). Here is the list of Tags and links to their respective Branches.
**[latest]** means the `latest` tag and `main` branch.
_[experimental]_ means that its image has been published but not supported yet for Rclex.

- [dashing-ex1.12.0-otp24.0.1](https://github.com/rclex/rclex_docker/tree/dashing-ex1.12.0-otp24.0.1)
- [dashing-ex1.11.2-otp23.3.1](https://github.com/rclex/rclex_docker/tree/dashing-ex1.11.2-otp23.3.1) **[latest]**
  - Note: [dashing-ex1.11.4-otp23.3.1](https://github.com/rclex/rclex_docker/tree/dashing-ex1.11.4-otp23.3.1) does not seem to buid the correct version of OTP. So we do not recommend to use it although it was published.  Also check [rclex/rclex#27](https://github.com/rclex/rclex/issues/27).
- [dashing-ex1.10.4-otp22.3.4](https://github.com/rclex/rclex_docker/tree/dashing-ex1.10.4-otp22.3.4)
- [dashing-ex1.9.4-otp22.3.4](https://github.com/rclex/rclex_docker/tree/dashing-ex1.9.1-otp22.3.4)
- [dashing-ex1.9.1-otp22.0.7](https://github.com/rclex/rclex_docker/tree/dashing-ex1.9.1-otp22.0.7)

- [foxy-ex1.11.2-otp23.3.1](https://github.com/rclex/rclex_docker/tree/foxy-ex1.11.2-otp23.3.1) _[experimental]_

_Note:_ README including the above list is surely maintained only on the [main branch](https://github.com/rclex/rclex_docker#the-rule-of-docker-tags-and-git-branches).
