defmodule ElixirBasicsTest do
  use ExUnit.Case
  doctest ElixirBasics

  test "greets the world" do
    assert ElixirBasics.hello() == :world
  end
end
