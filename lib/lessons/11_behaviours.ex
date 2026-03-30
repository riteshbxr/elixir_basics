defmodule ElixirBasics.Lessons.Behaviours do
  # ── Defining a behaviour ───────────────────────────────────────────────
  # A behaviour is a contract: any module that declares `@behaviour Greeter`
  # MUST implement all non-optional callbacks or get a compile-time warning.
  # Think of it as Elixir's version of an interface or abstract class.
  defmodule Greeter do
    @callback greet(name :: String.t()) :: String.t()
    @callback farewell(name :: String.t()) :: String.t()
    @callback shout(name :: String.t()) :: String.t()

    # @optional_callbacks lists callbacks that implementors may skip.
    # Omitting a non-optional callback is a compile-time warning.
    @optional_callbacks shout: 1
  end

  # ── Implementing a behaviour ───────────────────────────────────────────
  # `@behaviour Greeter` declares this module implements the contract.
  # `@impl true` tells the compiler each function is a callback implementation
  # — it will error if the function signature doesn't match any @callback.
  defmodule CasualGreeter do
    @behaviour Greeter

    @impl true
    def greet(name), do: "Hey #{name}!"

    @impl true
    def farewell(name), do: "See ya, #{name}!"

    # shout/1 is optional — CasualGreeter doesn't implement it, and that's fine
  end

  defmodule FormalGreeter do
    @behaviour Greeter

    @impl true
    def greet(name), do: "Good day, #{name}."

    @impl true
    def farewell(name), do: "Farewell, #{name}."

    @impl true
    def shout(name), do: "Heyyyyyyyyyyyyyyyyy #{name}!"   # implements the optional callback
  end

  # ── Runtime check for optional callbacks ──────────────────────────────
  # function_exported?(module, function, arity) returns true if the module
  # exports that function — useful to check for optional callbacks at runtime.
  def shout_someone(greeter, name) do
    shout =
      if function_exported?(greeter, :shout, 1) do
        greeter.shout(name)
      else
        "(no shout available)"   # CasualGreeter lands here
      end

    "#{inspect(greeter)} | #{shout}"
  end

  # ── Polymorphism via module as argument ────────────────────────────────
  # The module itself is passed as a value and called dynamically.
  # This is behaviours' superpower: swap implementations without changing callers.
  def greet_someone(greeter, name) do
    greeter.greet(name)   # dispatches to whichever module is passed in
  end

  def run do
    greet_someone(FormalGreeter, "Alice") |> IO.puts()
    greet_someone(CasualGreeter, "Alice") |> IO.puts()

    shout_someone(FormalGreeter, "Alice") |> IO.puts()   # has shout
    shout_someone(CasualGreeter, "Alice") |> IO.puts()   # no shout — fallback
  end
end
