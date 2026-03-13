defmodule ElixirBasics.Lessons.Collections do
  def typeof(x) do
    cond do
      is_integer(x) -> "integer"
      is_float(x) -> "float"
      is_binary(x) -> "string"
      is_atom(x) -> "atom"
      is_list(x) -> "list"
      is_map(x) -> "map"
      is_tuple(x) -> "tuple"
      is_boolean(x) -> "boolean"
      true -> "unknown"
    end
  end

  def run do
    user = %{name: "Ritesh", age: 30}
    user = Map.put(user, :email, "r@example.com")
    IO.puts(inspect(user))
    user = Map.delete(user, :age)
    IO.puts(inspect(user))
    %{name: namex}=user;
     IO.puts("extracted name: #{namex}")
    IO.puts(String.duplicate("--", 30))

    # Shorthand syntax for keyword lists
    opts = [timeout: 5000, retries: 3]
    IO.puts(opts[:timeout])
    IO.puts(opts[:retries])
    IO.puts("opts Type: " <> typeof(opts))

    # Keys can repeat (unlike Map)
    headers = [accept: "json", accept: "xml"]
    IO.puts(inspect(headers))
    IO.puts(Keyword.get_values(headers, :accept) |> Enum.join(","))

    IO.puts(
      headers
      |> Enum.map(fn {key, val} -> Atom.to_string(key) <> ">" <> val end)
      |> Enum.join(",")
    )

    IO.puts(
      headers
      |> Enum.map(&"#{Atom.to_string(elem(&1, 0))}>#{elem(&1, 1)}|#{inspect(&1)}")
      |> Enum.join(",")
    )

    IO.puts(String.duplicate("--", 20))

    point = {10, 20}
    {x, y} = point
    IO.puts(inspect(point))
    IO.puts("x=#{x}, y=#{y}")

    # Common as tagged results
    IO.puts(inspect({:ok, "data"}))
    IO.puts(inspect({:error, "not found"}))

    # Map — key-value store, any type as key
    user = %{name: "Ritesh", age: 30, role: :admin}
    IO.puts(user.name)
    IO.puts(user[:age])

    user2 = %{user | age: 31}
    IO.puts("updated age: #{user2.age}")
    IO.puts("original age: #{user.age}")

    IO.puts(String.duplicate("--", 20))
    # List ordered
    nums = [1, 2, 3, 4, 5]
    IO.puts(inspect(nums))

    # Prepend with | (fast)
    nums2 = [0 | nums]
    IO.puts(inspect(nums2))

    # Head Tail
    [first | rest] = nums
    IO.puts("first: #{first}, rest: #{inspect(rest)}")

    # Common List functions
    IO.puts(length(nums))
    IO.puts(inspect(Enum.reverse(nums)))
    IO.puts(inspect(nums ++ [6, 7]))
  end
end
