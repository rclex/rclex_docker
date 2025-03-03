defmodule Mix.Tasks.RclexDocker do
  @shortdoc "Shows rclex docker targets which this tasks can build and push"
  @moduledoc """
  #{@shortdoc}
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

  def latest_target_tuple() do
    {"hexpm/elixir:1.17.3-erlang-27.2.4-ubuntu-jammy-20250126", "humble"}
  end

  def list_target_tuples() do
    [
      ### Humble
      {"hexpm/elixir:1.18.2-erlang-27.2.4-ubuntu-jammy-20250126", "humble"},
      {"hexpm/elixir:1.17.3-erlang-27.2.4-ubuntu-jammy-20250126", "humble"},
      {"hexpm/elixir:1.16.3-erlang-26.2.5-ubuntu-jammy-20240530", "humble"},
      ### Jazzy
      {"hexpm/elixir:1.18.2-erlang-27.2.4-ubuntu-noble-20250127", "jazzy"},
      {"hexpm/elixir:1.17.3-erlang-27.2.4-ubuntu-noble-20250127", "jazzy"},
      {"hexpm/elixir:1.16.3-erlang-26.2.5-ubuntu-noble-20240530", "jazzy"}
      ##### The below are already deprecated versions
      ### Dashing
      # {"hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-bionic-20210325", "dashing"},
      # {"hexpm/elixir:1.11.4-erlang-23.3.4-ubuntu-bionic-20210325", "dashing"},
      # {"hexpm/elixir:1.10.4-erlang-23.3.4-ubuntu-bionic-20210325", "dashing"},
      # {"hexpm/elixir:1.9.4-erlang-22.3.4.18-ubuntu-bionic-20210325", "dashing"},
      ### Foxy
      # {"hexpm/elixir:1.15.5-erlang-26.0.2-ubuntu-focal-20230126", "foxy"},
      # {"hexpm/elixir:1.14.5-erlang-25.3.2.5-ubuntu-focal-20230126", "foxy"},
      # {"hexpm/elixir:1.14.0-erlang-25.0.4-ubuntu-focal-20211006", "foxy"},
      # {"hexpm/elixir:1.13.4-erlang-25.0.3-ubuntu-focal-20211006", "foxy"},
      # {"hexpm/elixir:1.13.1-erlang-24.1.7-ubuntu-focal-20210325", "foxy"},
      # {"hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-focal-20210325", "foxy"},
      # {"hexpm/elixir:1.11.4-erlang-23.3.4-ubuntu-focal-20210325", "foxy"},
      ### Galactic
      # {"hexpm/elixir:1.15.5-erlang-26.0.2-ubuntu-focal-20230126", "galactic"},
      # {"hexpm/elixir:1.13.4-erlang-25.0.3-ubuntu-focal-20211006", "galactic"},
      # {"hexpm/elixir:1.13.1-erlang-24.1.7-ubuntu-focal-20210325", "galactic"},
      # {"hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-focal-20210325", "galactic"},
      # {"hexpm/elixir:1.11.4-erlang-23.3.4-ubuntu-focal-20210325", "galactic"},
      ### Humble
      # {"hexpm/elixir:1.16.2-erlang-26.2.2-ubuntu-jammy-20240125", "humble"},
      # {"hexpm/elixir:1.15.7-erlang-26.2.2-ubuntu-jammy-20240125", "humble"},
      # {"hexpm/elixir:1.15.5-erlang-26.0.2-ubuntu-jammy-20230126", "humble"},
      # {"hexpm/elixir:1.14.5-erlang-25.3.2.5-ubuntu-jammy-20230126", "humble"},
      # {"hexpm/elixir:1.13.4-erlang-25.0.3-ubuntu-jammy-20220428", "humble"},
      # {"hexpm/elixir:1.13.4-erlang-24.3.4.2-ubuntu-jammy-20220428", "humble"}
      ### Iron
      # {"hexpm/elixir:1.15.5-erlang-26.0.2-ubuntu-jammy-20230126", "iron"},
    ]
  end

  @spec latest_target() :: Target.t()
  def latest_target() do
    {base_image, ros_distribution} = latest_target_tuple()

    %Target{
      base_image: base_image,
      ros_distribution: ros_distribution
    }
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
      ~r"hexpm/elixir:(?<elixir_version>\d+\.\d+\.\d+)-erlang-(?<erlang_otp_version>\d+\.\d+(\.\d+)?(\.\d+)?)-ubuntu-(?<ubuntu_codename>[a-z]+)-(?<build_date>[0-9]{8}).*",
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

  def docker_command_exists?() do
    not is_nil(System.find_executable("docker"))
  end
end
