defmodule ElixirBasics.Lessons.ControlFlow do
  def _check_age_with_if(age) do
    if(age >= 18) do
      "Adult"
    else
      "Minor"
    end
  end

  def check_age(age) do
    cond do
      age >= 50 -> "Old"
      age >= 18 -> "Adult"
      true -> "Minor"
    end
  end

  def http_response(code) do
    case code do
      200 -> {:ok, "OK"}
      404 -> {:not_found, "Not Found"}
      500 -> {:server_error, "Server Error"}
      _ -> {:unknown, "Unknown Error: #{code}"}
    end
  end

  def process_user(params) do
    with {:ok, name} <- Map.fetch(params, :name),
         {:ok, age} <- Map.fetch(params, :age),
         true <- age >= 18 do
      "Welcome, #{name}!"
    else
      :error -> "Missing required field"
      false -> "Must be 18 or older"
    end
  end

  def run do
    IO.puts(process_user(%{name: "Ritesh", age: 25}))
    IO.puts(process_user(%{name: "Bob", age: 16}))
    IO.puts(process_user(%{age: 25}))
    IO.puts(process_user(%{age: 12}))
    IO.puts(String.duplicate("-", 30))

    {_, msg} = http_response(200)
    IO.puts(msg)
    {_, msg} = http_response(404)
    IO.puts(msg)
    {_, msg} = http_response(503)
    IO.puts(msg)
    IO.puts(String.duplicate("-", 30))

    IO.puts("Age 20 is " <> check_age(20))
    IO.puts("Age 70 is " <> check_age(70))
    IO.puts("Age 15 is " <> check_age(15))
  end
end
