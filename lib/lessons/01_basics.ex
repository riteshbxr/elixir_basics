defmodule ElixirBasics.Lessons.Basics do
  @moduledoc """
  Lesson 1: Basic Types & Pattern Matching

  Run in iex with:
    iex -S mix
    ElixirBasics.Lessons.Basics.run()
  """

  def run do
    IO.puts("\n=== 1. Basic Types ===")

    # Integers and floats
    age = 30
    pi = 3.14
    IO.puts("Integer: #{age}")
    IO.puts("Float: #{pi}")

    # Atoms — like symbols, always start with colon
    # They are constants whose name is their value
    status = :ok
    IO.puts("Atom: #{status}")

    # Strings — UTF-8 encoded binaries
    name = "Elixir"
    IO.puts("String: #{name}, length: #{String.length(name)}")

    # Booleans (actually atoms :true and :false)
    IO.puts("true is atom? #{is_atom(true)}")

    IO.puts("\n=== 2. Immutability ===")
    # Variables are immutable — rebinding creates a new binding
    x = 10
    x = x + 5  # This rebinds x, not mutation
    IO.puts("x after rebind: #{x}")

    IO.puts("\n=== 3. Pattern Matching ===")
    # = is the MATCH operator, not assignment
    # Left side is matched against right side

    # Match a tuple
    {:ok, value} = {:ok, 42}
    IO.puts("Matched value from tuple: #{value}")

    # Match a list head and tail
    [head | tail] = [1, 2, 3, 4]
    IO.puts("Head: #{head}, Tail: #{inspect(tail)}")

    # Ignore a value with underscore
    {_, second} = {"ignored", "kept"}
    IO.puts("Second element: #{second}")

    IO.puts("\n=== 4. Pin Operator ^ ===")
    # Use ^ to match against an existing variable's value
    expected = :ok
    result = :ok
    ^expected = result  # This would raise if result != :ok
    IO.puts("Pin match succeeded — result was :ok")

    :done
  end
end
