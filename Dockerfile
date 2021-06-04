# base image
FROM ros:foxy

# update sources list
RUN apt-get clean
RUN apt-get update

# install Elixir
RUN apt-get install -y wget
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
  sudo dpkg -i erlang-solutions_2.0_all.deb && \
  rm -f erlang-solutions_2.0_all.deb
RUN apt-get update
RUN apt-cache showpkg elixir | grep 1.11.2
RUN apt-get install -y esl-erlang=1:23.3.1-1
RUN apt-get install -y elixir=1.11.2-1

# cleanup
RUN apt-get -qy autoremove

# install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# check version
RUN env | grep ROS
RUN mix hex.info

