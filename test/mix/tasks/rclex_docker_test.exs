defmodule Mix.Tasks.RclexDockerTest do
  use ExUnit.Case

  alias Mix.Tasks.RclexDocker

  doctest RclexDocker

  test "greets the world" do
    assert RclexDocker.hello() == :world
  end
end
