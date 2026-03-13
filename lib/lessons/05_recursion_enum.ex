defmodule ElixirBasics.Lessons.RecursionEnum do
  def sum_tail(list, acc \\ 0)
  def sum_tail([], acc), do: acc
  def sum_tail([head | tail], acc), do: sum_tail(tail, acc + head)

  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)

  def fact(1), do: 1
  def fact(n) when n > 0, do: n * fact(n - 1)

  def run do
        words = ["hello", "world", "from", "elixir"]

    longest =
      Enum.reduce(words, "", fn word, acc ->
        if String.length(word) > String.length(acc), do: word, else: acc
      end)
    IO.puts("longest word: #{longest}")

    counts = Enum.reduce(words, %{}, fn word, acc ->
      Map.put(acc, word, String.length(word))
    end)
    IO.puts(inspect(counts))
    IO.puts(String.duplicate("---", 30))
    
    nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    IO.puts(inspect(Enum.map(nums, &(&1 * 2))))
    IO.puts(inspect(Enum.filter(nums, &(rem(&1, 2) == 0))))
    IO.puts(inspect(Enum.reduce(nums, 0, &(&1 + &2))))
    IO.puts(inspect(Enum.take(nums, 3)))
    IO.puts(inspect(Enum.drop(nums, 7),charlists: :as_lists))

    result =
      nums
      # Filter Even Nos
      |> Enum.filter(&(rem(&1, 2) == 0))
      # Square them up
      |> Enum.map(&(&1 * &1))
      # add them
      |> Enum.sum()

    IO.puts("sum of squares of evens: #{result}")

    IO.puts(String.duplicate("---", 30))
    IO.puts(sum_tail([1, 2, 3, 4, 5]))
    IO.puts(sum([1, 2, 3, 4, 5]))
    IO.puts(fact(6))
  end
end
