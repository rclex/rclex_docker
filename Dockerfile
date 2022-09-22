### FIXME according to the target version
# base image, ARG is overridable by --build-arg
ARG BASE_IMAGE=hexpm/elixir:1.13.4-erlang-25.0.3-ubuntu-focal-20211006
FROM $BASE_IMAGE
# Set Ubuntu Codename ENV, ARG is overridable by --build-arg
ARG UBUNTU_CODENAME
ENV UBUNTU_CODENAME=${UBUNTU_CODENAME:-focal}
# Set ROS_DISTRO ENV, ARG is overridable by --build-arg
ARG ROS_DISTRO
ENV ROS_DISTRO=${ROS_DISTRO:-foxy}

# force error about debconf
ENV DEBIAN_FRONTEND noninteractive

# update sources list
RUN apt-get clean
RUN apt-get update

# install additonal packages
RUN apt-get install -y git sudo build-essential

# install AStyle to format C code (NIFs)
RUN apt-get install -y astyle

### install ROS START
### https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html

# Set locale
RUN apt-get update && apt-get -y install locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# Setup Sources
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu ${UBUNTU_CODENAME} main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 packages
RUN apt-get update
RUN apt-get install -y ros-${ROS_DISTRO}-ros-base

# Install ROS 2 packages
RUN apt-get install -y python3-colcon-common-extensions

# Setup ROS environment in shell
RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.sh' >> ~/.bashrc

### install ROS END

# for mix test.watch
RUN apt-get install -y inotify-tools

# cleanup
RUN apt-get -qy autoremove

# install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# check version
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && env | grep ROS
RUN mix hex.info

COPY docker-entrypoint.sh /root/
RUN chmod +x /root/docker-entrypoint.sh
ENTRYPOINT ["/root/docker-entrypoint.sh"]
CMD ["/bin/bash"]
