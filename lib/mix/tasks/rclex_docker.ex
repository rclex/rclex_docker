defmodule Mix.Tasks.RclexDocker do
  @moduledoc """
  Shows rclex docker targets which this tasks can build and push.
  """

  use Mix.Task

  defmodule Target do
    @moduledoc false
    @type t :: %__MODULE__{base_image: String.t(), ros_distribution: String.t()}
    defstruct base_image: "", ros_distribution: ""
  end

  def run(_) do
    for target <- list_target() do
      "#{String.pad_trailing(target.ros_distribution, 10)} on #{target.base_image}"
      |> IO.puts()
    end
  end

  def list_target_tuples() do
    [
      {"hexpm/elixir:1.9.4-erlang-22.3.4.18-ubuntu-bionic-20210325", "dashing"},
      {"hexpm/elixir:1.10.4-erlang-23.3.4-ubuntu-bionic-20210325", "dashing"},
      {"hexpm/elixir:1.11.4-erlang-23.3.4-ubuntu-bionic-20210325", "dashing"},
      {"hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-bionic-20210325", "dashing"},
      {"hexpm/elixir:1.11.4-erlang-23.3.4-ubuntu-focal-20210325", "foxy"},
      {"hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-focal-20210325", "foxy"},
      {"hexpm/elixir:1.13.1-erlang-24.1.7-ubuntu-focal-20210325", "foxy"},
      {"hexpm/elixir:1.11.4-erlang-23.3.4-ubuntu-focal-20210325", "galactic"},
      {"hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-focal-20210325", "galactic"},
      {"hexpm/elixir:1.13.1-erlang-24.1.7-ubuntu-focal-20210325", "galactic"},
      {"hexpm/elixir:1.13.4-erlang-24.3.4.2-ubuntu-jammy-20220428", "humble"}
    ]
  end

  @spec list_target() :: [Target.t()]
  def list_target() do
    list_target_tuples()
    |> Enum.map(fn {base_image, ros_distribution} ->
      %Target{
        base_image: base_image,
        ros_distribution: ros_distribution
      }
    end)
  end

  @doc """
      iex> alias Mix.Tasks.RclexDocker
      iex> RclexDocker.parse_base_image_name("hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-focal-20210325")
      %{
        "build_date" => "20210325",
        "elixir_version" => "1.12.3",
        "erlang_otp_version" => "24.1.5",
        "ubuntu_codename" => "focal"
      }
      iex> RclexDocker.parse_base_image_name("hexpm/elixir:1.9.4-erlang-22.3.4.18-ubuntu-bionic-20210325")
      %{
        "build_date" => "20210325",
        "elixir_version" => "1.9.4",
        "erlang_otp_version" => "22.3.4.18",
        "ubuntu_codename" => "bionic"
      }
  """
  def parse_base_image_name(base_image_name) do
    Regex.named_captures(
      ~r"hexpm/elixir:(?<elixir_version>\d+\.\d+\.\d+)-erlang-(?<erlang_otp_version>\d+\.\d+\.\d+(\.\d+)?)-ubuntu-(?<ubuntu_codename>[a-z]+)-(?<build_date>[0-9]{8})",
      base_image_name
    )
  end

  @doc """
  ## Examples

      iex> alias Mix.Tasks.RclexDocker
      iex> RclexDocker.parse_base_image_name("hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-focal-20210325") |>
      iex> RclexDocker.create_tag("foxy")
      "foxy-ex1.12.3-otp24.1.5"
      
  """
  def create_tag(%{} = parsed_map, ros_distribution) do
    %{
      "elixir_version" => elixir_version,
      "erlang_otp_version" => erlang_otp_version
    } = parsed_map

    "#{ros_distribution}-ex#{elixir_version}-otp#{erlang_otp_version}"
  end

  # TODO: implement
  def docker_command_exists?() do
    true
  end

  @doc """
  Hello world.

  ## Examples

      iex> RclexDocker.hello()
      :world

  """
  def hello do
    :world
  end
end
