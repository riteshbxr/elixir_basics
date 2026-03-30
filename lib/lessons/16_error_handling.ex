defmodule ElixirBasics.Lessons.ErrorHandling do
  # ── Tagged tuples — the idiomatic Elixir approach ─────────────────────
  # Model failure as data: return {:ok, value} or {:error, reason}.
  # The caller pattern-matches on the result — no exceptions needed.
  defp divide(_, 0), do: {:error, :division_by_zero}
  defp divide(a, b), do: {:ok, a / b}

  # ── Custom exceptions with defexception ───────────────────────────────
  # defexception creates a struct that implements the Exception behaviour.
  # `message:` sets the default message shown in stack traces.
  defmodule ValidationError do
    defexception message: "validation failed"
  end

  # ── raise/rescue for unexpected failures ──────────────────────────────
  # Use raise when the failure is truly exceptional (programmer error).
  # For expected failures (like bad user input), prefer tagged tuples.
  defp validate_age(age) when age < 0 do
    raise ValidationError, message: "age cannot be negative: #{age}"
  end

  defp validate_age(age), do: {:ok, age}

  # ── Non-bang vs bang functions ────────────────────────────────────────
  # Non-bang: returns tagged tuple, caller decides how to handle failure
  defp safe_divide(v, 0), do: {:error, "cannot divide by zero #{v}/0"}
  defp safe_divide(a, b), do: {:ok, a / b}

  # Bang (!): raises on failure — use when failure = programmer error
  defp safe_divide!(a, b) do
    case safe_divide(a, b) do
      {:ok, result} -> result
      {:error, reason} -> raise RuntimeError, message: reason
    end
  end

  def run do
    IO.puts("=== Error Handling ===\n")

    # ── 1. Tagged tuples ─────────────────────────────────────────────────
    # The standard Elixir pattern — match on {:ok, _} or {:error, _}.
    IO.puts("-- Tagged tuples --")

    case divide(10, 2) do
      {:ok, result} -> IO.puts("10 / 2 = #{result}")
      {:error, reason} -> IO.puts("Error: #{reason}")
    end

    case divide(10, 0) do
      {:ok, result} -> IO.puts("10 / 0 = #{result}")
      {:error, reason} -> IO.puts("Error: #{reason}")    # :division_by_zero
    end

    # ── 2. try/rescue ─────────────────────────────────────────────────────
    # Use when calling code that raises (often stdlib or third-party).
    # `try` is an expression — it returns the value of the matching clause.
    # `e in ArgumentError` catches only that exception type.
    IO.puts("\n-- try/rescue --")

    result =
      try do
        String.to_integer("not_a_number")   # raises ArgumentError
      rescue
        e in ArgumentError -> {:error, Exception.message(e)}
      end

    IO.inspect(result, label: "parse result")   # {:error, "..."}

    result2 =
      try do
        String.to_integer("42")   # succeeds — rescue clause not entered
      rescue
        e in ArgumentError -> {:error, Exception.message(e)}
      end

    IO.inspect(result2, label: "parse result2")   # 42 (integer)

    # ── 3. try/after ─────────────────────────────────────────────────────
    # `after` runs unconditionally — even if an exception is raised.
    # Useful for cleanup (close a file, release a lock, etc.).
    # The `after` block does NOT affect the return value of `try`.
    IO.puts("\n-- try/after --")

    try do
      IO.puts("doing work...")
      String.to_integer("bad")
    rescue
      e in ArgumentError -> IO.puts("rescued: #{Exception.message(e)}")
    after
      IO.puts("cleanup always runs")   # runs whether rescue triggered or not
    end

    # ── 4. Custom exceptions ──────────────────────────────────────────────
    # Raise our custom ValidationError and catch it by type.
    # `e.message` accesses the message field on the exception struct.
    IO.puts("\n-- raise / defexception --")

    try do
      validate_age(-5)
    rescue
      e in ValidationError -> IO.puts("caught: #{e.message}")
    end

    IO.inspect(validate_age(25), label: "valid age")   # {:ok, 25}

    # ── 5. throw/catch ────────────────────────────────────────────────────
    # throw/catch is for non-local early exits — breaking out of deep nesting.
    # Rare in Elixir; prefer Enum.find or explicit recursion instead.
    IO.puts("\n-- throw/catch --")

    result =
      try do
        Enum.each(1..10, fn n ->
          if n == 5, do: throw({:found, n})   # non-local jump out of Enum.each
        end)

        :not_found   # only reached if throw is never called
      catch
        {:found, n} -> {:ok, n}   # caught here
      end

    IO.inspect(result, label: "first multiple of 5")

    # ── 6. Bang vs non-bang ───────────────────────────────────────────────
    IO.puts("\n-- bang vs non-bang --")

    # non-bang: returns tagged tuple, you handle it
    case safe_divide(3, 0) do
      {:ok, value} -> IO.puts("result is #{value}")
      {:error, reason} -> IO.puts("could not read: #{reason}")
    end

    # bang: raises on failure, use when failure = programmer error
    value = safe_divide!(6, 2)
    IO.puts("Divide with Bang #{value}")

    # bang raises RuntimeError on bad input
    try do
      safe_divide!(6, 0)
    rescue
      e in RuntimeError -> IO.puts("Error: #{Exception.message(e)}")
    end
  end
end
