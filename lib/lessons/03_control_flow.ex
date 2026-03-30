defmodule ElixirBasics.Lessons.ControlFlow do
  # ── if / else ─────────────────────────────────────────────────────────
  # `if` is an expression — it returns a value, not just a statement.
  # The _ prefix marks this as a reference version kept for comparison.
  def _check_age_with_if(age) do
    if(age >= 18) do
      "Adult"
    else
      "Minor"
    end
  end

  # ── cond ──────────────────────────────────────────────────────────────
  # Use cond when you have multiple conditions to check in sequence.
  # Each clause is a truthy expression → result.
  # `true` at the end is the catch-all (required if no other clause matches).
  def check_age(age) do
    cond do
      age >= 50 -> "Old"
      age >= 18 -> "Adult"
      true -> "Minor"   # fallback — always matches
    end
  end

  # ── case ──────────────────────────────────────────────────────────────
  # Use case to match on the shape or value of a single expression.
  # Each clause is a pattern → result. _ matches anything not caught above.
  def http_response(code) do
    case code do
      200 -> {:ok, "OK"}
      404 -> {:not_found, "Not Found"}
      500 -> {:server_error, "Server Error"}
      _ -> {:unknown, "Unknown Error: #{code}"}   # wildcard fallback
    end
  end

  # ── with ──────────────────────────────────────────────────────────────
  # Use with to chain steps that might fail.
  # Each `<-` line binds a result; if any step doesn't match, the `else`
  # block handles it — no nested if/case needed.
  def process_user(params) do
    with {:ok, name} <- Map.fetch(params, :name),   # fails with :error if :name missing
         {:ok, age} <- Map.fetch(params, :age),     # fails with :error if :age missing
         true <- age >= 18 do                       # fails with false if under 18
      "Welcome, #{name}!"
    else
      :error -> "Missing required field"   # Map.fetch returned :error
      false -> "Must be 18 or older"      # age check returned false
    end
  end

  def run do
    IO.puts(process_user(%{name: "Ritesh", age: 25}))
    IO.puts(process_user(%{name: "Bob", age: 16}))
    IO.puts(process_user(%{age: 25}))    # :name missing
    IO.puts(process_user(%{age: 12}))   # age < 18
    IO.puts(String.duplicate("-", 30))

    # Pattern match the tuple returned by http_response, ignoring the tag
    {_, msg} = http_response(200)
    IO.puts(msg)
    {_, msg} = http_response(404)
    IO.puts(msg)
    {_, msg} = http_response(503)    # matches _ wildcard
    IO.puts(msg)
    IO.puts(String.duplicate("-", 30))

    IO.puts("Age 20 is " <> check_age(20))
    IO.puts("Age 70 is " <> check_age(70))
    IO.puts("Age 15 is " <> check_age(15))
  end
end
