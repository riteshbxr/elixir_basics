defmodule ElixirBasics.Lessons.Collections do
  # ── typeof helper ─────────────────────────────────────────────────────
  # is_* guard functions work in cond/case/guards to check a value's type.
  # Note: is_boolean must come BEFORE is_atom because true/false are atoms.
  def typeof(x) do
    cond do
      is_integer(x) -> "integer"
      is_float(x) -> "float"
      is_binary(x) -> "string"    # strings are called "binaries" internally
      is_atom(x) -> "atom"
      is_list(x) -> "list"
      is_map(x) -> "map"
      is_tuple(x) -> "tuple"
      is_boolean(x) -> "boolean"
      true -> "unknown"
    end
  end

  def run do
    # ── Maps ────────────────────────────────────────────────────────────
    # Map — key-value store with unique keys. %{key: value} syntax.
    user = %{name: "Ritesh", age: 30}

    # Map.put returns a NEW map — data is immutable, rebind the variable
    user = Map.put(user, :email, "r@example.com")
    IO.puts(inspect(user))

    user = Map.delete(user, :age)
    IO.puts(inspect(user))

    # Partial pattern match — extract just the field you need
    %{name: namex} = user
    IO.puts("extracted name: #{namex}")
    IO.puts(String.duplicate("--", 30))

    # ── Keyword Lists ────────────────────────────────────────────────────
    # A keyword list is a list of {atom, value} pairs with shorthand syntax.
    # Used for options/config — ordered, allows duplicate keys.
    opts = [timeout: 5000, retries: 3]
    IO.puts(opts[:timeout])
    IO.puts(opts[:retries])
    IO.puts("opts Type: " <> typeof(opts))

    # Unlike Map, keyword lists allow duplicate keys
    headers = [accept: "json", accept: "xml"]
    IO.puts(inspect(headers))

    # Keyword.get_values returns ALL values for a repeated key
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

    # ── Tuples ──────────────────────────────────────────────────────────
    # Tuple — fixed-size, fast indexed access, stored contiguously in memory.
    # Best for grouping a small, known number of values (often 2-3).
    point = {10, 20}
    {x, y} = point    # destructure with pattern matching
    IO.puts(inspect(point))
    IO.puts("x=#{x}, y=#{y}")

    # Most common use: tagged result tuples to signal success or failure
    IO.puts(inspect({:ok, "data"}))
    IO.puts(inspect({:error, "not found"}))

    # ── Map (revisited) ──────────────────────────────────────────────────
    user = %{name: "Ritesh", age: 30, role: :admin}
    IO.puts(user.name)     # dot syntax — raises if key missing
    IO.puts(user[:age])    # bracket syntax — returns nil if key missing

    # %{map | key: new_value} — update syntax, raises if key doesn't exist
    user2 = %{user | age: 31}
    IO.puts("updated age: #{user2.age}")
    IO.puts("original age: #{user.age}")    # original unchanged

    IO.puts(String.duplicate("--", 20))

    # ── Lists ────────────────────────────────────────────────────────────
    # List — ordered, singly-linked. Good for sequences and recursion.
    # Prepending is O(1); appending with ++ is O(n).
    nums = [1, 2, 3, 4, 5]
    IO.puts(inspect(nums))

    # [new_element | existing_list] — prepend (fast)
    nums2 = [0 | nums]
    IO.puts(inspect(nums2))

    # Destructure head (first) and tail (rest of list) with pattern matching
    [first | rest] = nums
    IO.puts("first: #{first}, rest: #{inspect(rest)}")

    IO.puts(length(nums))
    IO.puts(inspect(Enum.reverse(nums)))
    IO.puts(inspect(nums ++ [6, 7]))    # ++ appends (creates new list)
  end
end
