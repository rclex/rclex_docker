defmodule Mix.Tasks.RclexDocker.Push do
  @moduledoc """
  Pushes rclex docker images

      $ mix rclex_docker.push [options]

  ## Options

  * --dry-run - show all raw docker commands which invoked by this task.
  * --latest - push only latest target.
  * --multi - push latest target for multi-platform.
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
      opts.latest == true -> push_latest(opts)
      opts.multi == true -> push_multi(opts)
      true -> push_all(opts)
    end
  end

  def push_latest(opts) do
    build_command("latest")
    |> docker_push(opts)
  end

  def push_multi(opts) do
    target = RclexDocker.latest_target()
    parsed_map = RclexDocker.parse_base_image_name(target.base_image)

    System.cmd("docker", ["buildx", "create", "--use", "--name", "rclex_builder"],
      into: IO.stream(:stdio, :line)
    )

    buildx_command(
      target.base_image,
      parsed_map["ubuntu_codename"],
      target.ros_distribution,
      "latest"
    )
    |> docker_push(opts)

    System.cmd("docker", ["buildx", "rm", "rclex_builder"], into: IO.stream(:stdio, :line))
  end

  def push_all(opts) do
    for %Target{} = target <- RclexDocker.list_target() do
      RclexDocker.parse_base_image_name(target.base_image)
      |> RclexDocker.create_tag(target.ros_distribution)
      |> build_command()
      |> docker_push(opts)
    end
  end

  def build_command(tag) do
    "docker push rclex/rclex_docker:#{tag} "
  end

  def buildx_command(base_iamge, ubuntu_codename, ros_distro, tag) do
    "docker buildx build " <>
      "--platform linux/amd64,linux/arm64 " <>
      "-f Dockerfile " <>
      "-t rclex/rclex_docker:#{tag} " <>
      "--build-arg BASE_IMAGE=#{base_iamge} " <>
      "--build-arg UBUNTU_CODENAME=#{ubuntu_codename} " <>
      "--build-arg ROS_DISTRO=#{ros_distro} " <>
      ". " <>
      "--push"
  end

  @spec docker_push(command :: String.t(), opts :: Options.t()) :: :ok
  def docker_push(command, opts \\ %Options{}) do
    if opts.dry_run do
      IO.puts(command)
    else
      IO.puts(command)
      docker_push_impl(command)
    end
  end

  @spec docker_push_impl(command :: String.t()) :: :ok
  def docker_push_impl(command) when is_binary(command) do
    [docker | args] = ~w"#{command}"

    case System.cmd(docker, args, into: IO.stream(:stdio, :line)) do
      {_, 0} ->
        Logger.info("docker push succeeded.")

      {_, exit_status} ->
        Logger.error("docker push failed, exit_status: #{exit_status}")
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
