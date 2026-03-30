defmodule ElixirBasics.Lessons.Functions do
  # ── Named functions with pattern matching ──────────────────────────────
  # A named function defined with `def` inside a module.
  # #{name} interpolates the variable into the string.
  def greet(name) do
    "Hello, #{name}!"
  end

  # Multiple clauses of the same function — Elixir tries them top-to-bottom
  # and uses the first clause whose argument pattern matches.
  def describe(:ok), do: "Everything is fine"
  def describe(:error), do: "Oh! it failed"
  def describe(_), do: "Hope Its Ok"  # _ is a wildcard, matches anything

  # ── Default arguments ──────────────────────────────────────────────────
  # \\ sets a default value. repeat("ha") uses times = 3 automatically.
  def repeat(message, times \\ 3) do
    (message <> " ")
    |> String.duplicate(times)
    |> String.trim()
  end

  # ── Guard clauses ──────────────────────────────────────────────────────
  # `when` adds an extra condition on top of pattern matching.
  # Elixir checks the guard only after the pattern matches.
  def classify(n) when n < 0, do: :negative
  def classify(0), do: :zero
  def classify(n) when n > 0, do: :positive

  # ── Typespecs with @spec ───────────────────────────────────────────────
  # @spec is optional documentation for tools like Dialyzer.
  # String.t() means "an Elixir string (binary)".
  @spec slugify(String.t()) :: String.t()
  def slugify(name) do
    name
    |> String.trim()           # remove leading/trailing whitespace
    |> String.downcase()       # "Alice" → "alice"
    |> String.replace(" ", "_")  # "alice smith" → "alice_smith"
  end

  def run do
    IO.puts(slugify("  Alice Smith  "))
    IO.puts(slugify("  BOB JONES  "))

    # ── Anonymous functions ────────────────────────────────────────────
    # fn ... end creates a lambda stored in a variable.
    # Anonymous functions MUST be called with a dot: fun.(args)
    add = fn a, b -> a + b end

    # & shorthand: &(&1 * 2) is the same as fn x -> x * 2 end
    # &1, &2, ... refer to the first, second, ... argument
    double = &(&1 * 2)

    # &Module.function/arity captures an existing named function
    shout = &String.upcase/2

    # Capture your own named function the same way
    classify2 = &classify/1

    IO.puts(add.(3, 4))              # dot required for anonymous fns
    IO.puts(double.(5))
    IO.puts(shout.("elixir", :ascii))
    IO.puts(classify2.(-5))

    IO.puts(repeat("ha"))            # uses default times = 3
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
