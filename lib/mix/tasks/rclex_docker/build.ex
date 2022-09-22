defmodule Mix.Tasks.RclexDocker.Build do
  @moduledoc """
  Builds rclex docker images

      $ mix rclex_docker.build [options]

  ## Options

  * --dry-run - show all raw docker commands which invoked by this task.
  * --latest - build only latest target.
  * --multi - build latest target for multi-platform.
  """

  use Mix.Task
  require Logger

  alias Mix.Tasks.RclexDocker
  alias Mix.Tasks.RclexDocker.Target

  defmodule Options do
    @moduledoc false
    @type t :: %__MODULE__{dry_run: boolean(), latest: boolean(), multi: boolean()}
    defstruct dry_run: false, latest: false, multi: false
  end

  def run(args) when is_list(args) do
    if not RclexDocker.docker_command_exists?() do
      raise RuntimeError, "docker command not found"
    end

    opts = parse_args(args)

    cond do
      opts.latest == true -> build_latest(opts)
      opts.multi == true -> build_multi(opts)
      true -> build_all(opts)
    end
  end

  def build_latest(opts) do
    target = RclexDocker.latest_target()
    parsed_map = RclexDocker.parse_base_image_name(target.base_image)

    build_command(
      target.base_image,
      parsed_map["ubuntu_codename"],
      target.ros_distribution,
      "latest"
    )
    |> docker_build(opts)
  end

  def build_multi(opts) do
    target = RclexDocker.latest_target()
    parsed_map = RclexDocker.parse_base_image_name(target.base_image)

    buildx_command(
      target.base_image,
      parsed_map["ubuntu_codename"],
      target.ros_distribution,
      "latest"
    )
    |> docker_build(opts)
  end

  def build_all(opts) do
    for %Target{} = target <- RclexDocker.list_target() do
      parsed_map = RclexDocker.parse_base_image_name(target.base_image)
      tag = RclexDocker.create_tag(parsed_map, target.ros_distribution)

      build_command(
        target.base_image,
        parsed_map["ubuntu_codename"],
        target.ros_distribution,
        tag
      )
      |> docker_build(opts)
    end
  end

  def build_command(base_iamge, ubuntu_codename, ros_distro, tag) do
    "docker build " <>
      "-f Dockerfile " <>
      "-t rclex/rclex_docker:#{tag} " <>
      "--no-cache " <>
      "--build-arg BASE_IMAGE=#{base_iamge} " <>
      "--build-arg UBUNTU_CODENAME=#{ubuntu_codename} " <>
      "--build-arg ROS_DISTRO=#{ros_distro} " <>
      "."
  end

  def buildx_command(base_iamge, ubuntu_codename, ros_distro, tag) do
    "docker buildx build " <>
      "--platform linux/amd64,linux/arm64 " <>
      "-f Dockerfile " <>
      "-t rclex/rclex_docker:#{tag} " <>
      "--no-cache " <>
      "--build-arg BASE_IMAGE=#{base_iamge} " <>
      "--build-arg UBUNTU_CODENAME=#{ubuntu_codename} " <>
      "--build-arg ROS_DISTRO=#{ros_distro} " <>
      "."
  end

  @spec docker_build(command :: String.t(), opts :: Options.t()) :: :ok
  def docker_build(command, opts \\ %Options{}) do
    if opts.dry_run do
      IO.puts(command)
    else
      IO.puts(command)
      docker_build_impl(command)
    end
  end

  @spec docker_build_impl(command :: String.t()) :: :ok
  def docker_build_impl(command) when is_binary(command) do
    [docker | args] = ~w"#{command}"

    case System.cmd(docker, args, into: IO.stream(:stdio, :line)) do
      {_, 0} ->
        Logger.info("docker build succeeded.")

      {_, exit_status} ->
        Logger.error("docker build failed, exit_status: #{exit_status}")
    end

    :ok
  end

  @doc """
      iex> alias Mix.Tasks.RclexDocker.{Build, Build.Options}
      iex> Build.parse_args(["--dry-run"])
      %Options{dry_run: true}
      iex> Build.parse_args([])
      %Options{dry_run: false}
  """
  @spec parse_args([String.t()]) :: Options.t()
  def(parse_args(args)) do
    Enum.reduce(args, %Options{}, fn arg, acc ->
      case arg do
        "--dry-run" -> %Options{acc | dry_run: true}
        "--latest" -> %Options{acc | latest: true}
        "--multi" -> %Options{acc | multi: true}
        _ -> acc
      end
    end)
  end
end
