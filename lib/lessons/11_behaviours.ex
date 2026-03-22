defmodule ElixirBasics.Lessons.Behaviours do
  defmodule Greeter do
    @callback greet(name :: String.t()) :: String.t()
    @callback farewell(name :: String.t()) :: String.t()
    @callback shout(name :: String.t()) :: String.t()

    @optional_callbacks shout: 1
  end

  defmodule CasualGreeter do
    @behaviour Greeter

    @impl true
    def greet(name), do: "Hey #{name}!"

    @impl true
    def farewell(name), do: "See ya, #{name}!"
  end

  defmodule FormalGreeter do
    @behaviour Greeter

    @impl true
    def greet(name), do: "Good day, #{name}."

    @impl true
    def farewell(name), do: "Farewell, #{name}."

    @impl true
    def shout(name), do: "Heyyyyyyyyyyyyyyyyy #{name}!"
  end

  def shout_someone(greeter, name) do
    shout =
      if function_exported?(greeter, :shout, 1) do
        greeter.shout(name)
      else
        "(no shout available)"
      end

    "#{inspect(greeter)} | #{shout}"
  end

  def greet_someone(greeter, name) do
    greeter.greet(name)
  end

  def run do
    greet_someone(FormalGreeter, "Alice") |> IO.puts()
    greet_someone(CasualGreeter, "Alice") |> IO.puts()

    shout_someone(FormalGreeter, "Alice") |> IO.puts()
    shout_someone(CasualGreeter, "Alice") |> IO.puts()
  end
end
