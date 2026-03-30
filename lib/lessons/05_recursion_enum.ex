defmodule ElixirBasics.Lessons.RecursionEnum do
  # ── Tail-recursive sum (stack-safe) ───────────────────────────────────
  # The accumulator `acc` carries the running total.
  # When the list is empty, return the accumulated result.
  # This is tail-recursive: the recursive call is the LAST thing, so Elixir
  # can reuse the current stack frame (Tail Call Optimization, TCO).
  def sum_tail(list, acc \\ 0)
  def sum_tail([], acc), do: acc
  def sum_tail([head | tail], acc), do: sum_tail(tail, acc + head)

  # ── Naive recursive sum (not tail-recursive) ───────────────────────────
  # The recursive call is inside `head + sum(tail)`, so each call waits
  # for the next to return — builds a stack frame per element.
  # Fine for small lists, but can crash with very large ones.
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)

  # ── Factorial (recursive) ──────────────────────────────────────────────
  # Base case: fact(1) = 1  (stops the recursion)
  # Recursive case: n! = n * (n-1)!
  def fact(1), do: 1
  def fact(n) when n > 0, do: n * fact(n - 1)

  def run do
    # ── Enum.reduce ───────────────────────────────────────────────────────
    # reduce(collection, initial_acc, fn element, acc -> new_acc end)
    # The accumulator can be any shape: number, map, string, list, etc.
    words = ["hello", "world", "from", "elixir"]

    # Accumulate the longest word seen so far
    longest =
      Enum.reduce(words, "", fn word, acc ->
        if String.length(word) > String.length(acc), do: word, else: acc
      end)
    IO.puts("longest word: #{longest}")

    # Accumulate into a map of {word => length}
    counts = Enum.reduce(words, %{}, fn word, acc ->
      Map.put(acc, word, String.length(word))
    end)
    IO.puts(inspect(counts))
    IO.puts(String.duplicate("---", 30))

    nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    # Enum.map — transform every element, return same-length list
    IO.puts(inspect(Enum.map(nums, &(&1 * 2))))

    # Enum.filter — keep only elements where the function returns true
    IO.puts(inspect(Enum.filter(nums, &(rem(&1, 2) == 0))))

    # Enum.reduce — fold all elements into a single value (sum here)
    IO.puts(inspect(Enum.reduce(nums, 0, &(&1 + &2))))

    # Enum.take / Enum.drop — slice a list by count
    IO.puts(inspect(Enum.take(nums, 3)))
    IO.puts(inspect(Enum.drop(nums, 7), charlists: :as_lists))

    # ── Pipeline combining Enum functions ─────────────────────────────────
    # Each step passes its result to the next via |>.
    # This reads like a recipe: filter → transform → aggregate.
    result =
      nums
      |> Enum.filter(&(rem(&1, 2) == 0))   # keep evens: [2,4,6,8,10]
      |> Enum.map(&(&1 * &1))               # square each: [4,16,36,64,100]
      |> Enum.sum()                         # add them: 220

    IO.puts("sum of squares of evens: #{result}")

    IO.puts(String.duplicate("---", 30))
    IO.puts(sum_tail([1, 2, 3, 4, 5]))   # tail-recursive, stack-safe
    IO.puts(sum([1, 2, 3, 4, 5]))         # naive recursion
    IO.puts(fact(6))                       # 6! = 720
  end
end
