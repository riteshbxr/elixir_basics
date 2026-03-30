defmodule ElixirBasics.Lessons.Streams do
  def run do
    IO.puts("=== Step 17: Streams ===\n")

    # Snippet 1 — Stream.map + Stream.filter (lazy pipeline)
    # Stream operations build a recipe; nothing runs until Enum.to_list forces it.
    # No intermediate list is allocated between map and filter.
    result =
      [1, 2, 3, 4, 5]
      |> Stream.map(fn x -> x * 2 end)
      |> Stream.filter(fn x -> x > 4 end)
      |> Enum.to_list()

    IO.inspect(result, label: "stream result")

    # Snippet 2 — Stream.iterate (infinite sequence)
    # iterate(seed, fun) generates: seed, fun.(seed), fun.(fun.(seed)), ... forever.
    # Enum.take/2 stops the stream after n elements — the only thing keeping it finite.
    IO.puts("\n-- infinite sequence --")
    naturals = Stream.iterate(1, fn n -> n + 1 end)
    IO.inspect(Enum.take(naturals, 10), label: "first 10 naturals")

    # Snippet 3 — Stream.unfold (stateful generation)
    # unfold({initial_state}, fun) where fun returns {value_to_emit, next_state}.
    # More powerful than iterate: accumulator can be richer than the emitted value.
    # Classic use: Fibonacci — emit a, next state is {b, a+b}.
    IO.puts("\n-- unfold: fibonacci --")

    fibs =
      Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)

    IO.inspect(Enum.take(fibs, 10), label: "first 10 fibs")

    # Snippet 4 — Stream.resource (wrap external resources)
    # Three functions: open / next / close.
    # next returns {[values], state} to continue, or {:halt, state} to stop.
    # This is the low-level primitive that File.stream! uses internally.
    IO.puts("\n-- resource: lazy file lines --")

    line_count =
      Stream.resource(
        fn -> File.open!("mix.exs") end,
        fn file ->
          case IO.read(file, :line) do
            :eof -> {:halt, file}
            line -> {[line], file}
          end
        end,
        fn file -> File.close(file) end
      )
      |> Enum.count()

    IO.puts("mix.exs has #{line_count} lines")

    # Snippet 5 — File.stream! pipeline (idiomatic file processing)
    # File.stream! wraps Stream.resource; reads one line at a time, never loads the whole file.
    # Stream.reject is the inverse of Stream.filter — keeps elements where predicate is false.
    # Stream.with_index(offset) pairs each element with its position starting at offset.
    # User explored: flipped reject logic to extract only comment lines.
    IO.puts("\n-- File.stream! pipeline, Filterling only comments --")

    "mix.exs"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == "" or !String.starts_with?(&1, "#")))
    |> Stream.with_index(1)
    |> Enum.each(fn {line, i} -> IO.puts("#{i}: #{line}") end)

    # Snippet 6 — Stream.chunk_every + Stream.zip
    # chunk_every(n) groups elements into sublists of size n; last chunk may be smaller.
    # chunk_every(n, step) with step < n gives a sliding window.
    # Charlist gotcha: integer sublists like [7,8,9] display as ~c"\a\b\t" — fix with charlists: :as_lists.
    # zip(a, b) pairs elements by position; stops when the shorter stream ends.
    # Useful to zip an infinite stream with a finite one safely.
    IO.puts("\n-- chunk_every --")

    1..10
    |> Stream.chunk_every(3)
    |> Enum.to_list()
    |> IO.inspect(label: "chunks of 3", charlists: :as_lists)

    IO.puts("\n-- zip --")

    Stream.zip(Stream.iterate(1, &(&1 + 1)), [:a, :b, :c, :d])
    |> Enum.to_list()
    |> IO.inspect(label: "zipped")

    # Snippet 7 — Stream.transform (stateful one-to-many)
    # The most general combinator: like reduce + flat_map combined.
    # fun receives {element, acc} and returns {[items_to_emit], new_acc}.
    # User explored: emitted "acc+x" formatted strings to make the running total readable.
    IO.puts("\n-- transform: running total --")

    1..6
    |> Stream.transform(0, fn x, acc ->
      new_acc = acc + x
      {[{"#{acc}+#{x}", new_acc}], new_acc}
    end)
    |> Enum.to_list()
    |> IO.inspect(label: "running totals")

    # Snippet 8 — Stream.flat_map (stateless one-to-many)
    # Simpler alternative to transform when no accumulator is needed.
    # Each element expands into a list; results are flattened into a single stream.
    # map is 1-to-1; flat_map is 1-to-many.
    IO.puts("\n-- flat_map --")

    [:a, :b, :c]
    |> Stream.flat_map(fn x -> [x, x, x] end)
    |> Enum.to_list()
    |> IO.inspect(label: "tripled atoms")
  end
end
