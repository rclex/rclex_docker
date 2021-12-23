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

Here is the list of Tags. They are associated with the ext of each Dockerfile on [GitHub repository](https://github.com/rclex/rclex_docker).

**[latest]** means the `latest` tag and `main` branch.

### Foxy Fitzroy

- foxy-ex1.13.1-otp24.1.7
- foxy-ex1.12.3-otp24.1.5 **[latest]**
- foxy-ex1.11.4-otp23.3.4

### Dashing Diademata

Note: Dashing has already reached EOL, so they are not recommended for use.

- dashing-ex1.12.3-otp24.1.5
- dashing-ex1.11.4-otp23.3.4
- dashing-ex1.10.4-otp23.3.4
- dashing-ex1.9.4-otp22.3.4.18

### _[experimental]_ Galactic Geochelone

Note: Galactic is not suppored yet for Rclex but these images are already published to Docker Hub for the future. 

- galactic-ex1.13.1-otp24.1.7
- galactic-ex1.12.3-otp24.1.5
- galactic-ex1.11.4-otp23.3.4

