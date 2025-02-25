# Setup the target version
## base image, ARG is overridable by --build-arg
ARG BASE_IMAGE=hexpm/elixir:1.15.7-erlang-26.2.3-ubuntu-jammy-20240125
FROM $BASE_IMAGE
## Set Ubuntu version by Codename, ARG is overridable by --build-arg
ARG UBUNTU_CODENAME
ENV UBUNTU_CODENAME=${UBUNTU_CODENAME:-jammy}
## Set ROS 2 distribution, ARG is overridable by --build-arg
ARG ROS_DISTRO
ENV ROS_DISTRO=${ROS_DISTRO:-jazzy}

# Force error about debconf
ENV DEBIAN_FRONTEND=noninteractive

# Install for rclex_docker
## inotify-tools: for mix test.watch
## astyle: to format C code in NIFs
RUN apt-get update && apt-get install -y \
  git sudo build-essential \
  inotify-tools \
  astyle \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install ROS START
## refer to https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debians.html

## Set locale
RUN apt-get update && apt-get -y install \
  locales \
  && locale-gen en_US en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && export LANG=en_US.UTF-8 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Setup Sources
RUN apt-get update && apt-get install -y \
  software-properties-common \
  curl \
  && sudo add-apt-repository universe \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu ${UBUNTU_CODENAME} main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

## Upgrade before installing ROS 2 packages
## WHY: refer to "Warning" in https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debians.html#install-ros-2-packages
RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Install ROS 2 packages
RUN apt-get update && apt-get install -y \
  ros-${ROS_DISTRO}-ros-base \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Install colcon-core
RUN apt-get update && apt-get install -y \
  python3-colcon-common-extensions \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Setup ROS environment in shell
RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.sh' >> ~/.bashrc

# Install ROS END

# cleanup
RUN apt-get -qy autoremove

# Install hex and rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# Check version
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && env | grep ROS && \
  mix hex.info

COPY docker-entrypoint.sh /root/
RUN chmod +x /root/docker-entrypoint.sh
ENTRYPOINT ["/root/docker-entrypoint.sh"]
CMD ["/bin/bash"]
