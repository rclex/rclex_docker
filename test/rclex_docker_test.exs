defmodule RclexDockerTest do
  use ExUnit.Case
  doctest RclexDocker

  test "greets the world" do
    assert RclexDocker.hello() == :world
  end
end
