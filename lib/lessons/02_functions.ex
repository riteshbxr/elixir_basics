defmodule ElixirBasics.Lessons.Functions do
  def greet(name) do
    "Hello, #{name}!"
  end

  def describe(:ok), do: "Everything is fine"
  def describe(:error), do: "Oh! it failed"
  def describe(_), do: "Hope Its Ok"

  def repeat(message, times \\ 3) do
    (message <> " ")
    |> String.duplicate(times)
    |> String.trim()
  end

  def classify(n) when n < 0, do: :negative
  def classify(0), do: :zero
  def classify(n) when n > 0, do: :positive

  @spec slugify(String.t()) :: String.t()
  def slugify(name) do
    name
    |> String.trim()
    |> String.downcase()
    |> String.replace(" ", "_")
  end

  def run do
    IO.puts(slugify("  Alice Smith  "))
    IO.puts(slugify("  BOB JONES  "))

    add = fn a, b -> a + b end
    double = &(&1 * 2)
    shout = &String.upcase/2
    classify2 = &classify/1

    IO.puts(add.(3, 4))
    IO.puts(double.(5))
    IO.puts(shout.("elixir", :ascii))
    IO.puts(classify2.(-5))

    IO.puts(repeat("ha"))
    IO.puts(repeat("hey", 2))
    IO.puts(classify(-5))
    IO.puts(classify(0))
    IO.puts(classify(7))

    IO.puts(greet("World"))
    IO.puts(describe(:ok))
    IO.puts(describe(:error))
    IO.puts(describe(:unknown))
  end
end
