defmodule ElixirBasics do
  @moduledoc """
  Documentation for `ElixirBasics`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ElixirBasics.hello()
      :world

  """
  def hello do
    IO.puts("Hello #{:world}")
    :world
  end
end
