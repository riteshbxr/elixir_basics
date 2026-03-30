defmodule ElixirBasics.Lessons.Sigils do
  # Snippet 5 — Custom sigil ~l
  # Defining sigil_X/2 makes ~X available in this module.
  # Elixir transforms ~l"..." into sigil_l("...", []) at compile time.
  # Modifiers after the closing delimiter are passed as a charlist, e.g. ~l"..."a → [?a].
  defp sigil_l(string, _modifiers) do
    string
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  def run do
    IO.puts("=== Step 18: Sigils ===\n")

    # Snippet 1 — ~r (Regex) and ~w (word list)
    # ~r compiles the regex at compile time — no re-parsing on every call.
    # Regex.match?/2 returns true/false.
    email_regex = ~r/^[^\s]+@[^\s]+\.[^\s]+$/
    IO.inspect(Regex.match?(email_regex, "user@example.com"), label: "valid email")
    IO.inspect(Regex.match?(email_regex, "not-an-email"), label: "invalid email")

    # ~w splits on whitespace and returns a list of strings by default.
    colors = ~w[red green blue]
    IO.inspect(colors, label: "colors")

    # Snippet 2 — ~w modifiers and ~s
    # ~w[...]a → list of atoms; ~w[...]c → list of charlists.
    # Atom modifier is idiomatic for role/status enumerations.
    roles = ~w[admin editor viewer]a
    IO.inspect(roles, label: "roles as atoms")

    # ~s — string sigil; supports #{interpolation} and \t \n escapes.
    # Useful when the string itself contains many double-quote characters.
    name = "Ritesh"
    greeting = ~s(Hello, #{name}!\tWelcome.)
    IO.puts(greeting)

    # Snippet 3 — ~D, ~T, ~N (date/time literals)
    # These produce real structs (%Date{}, %Time{}, %NaiveDateTime{}), not strings.
    # IO.inspect prints them back as their sigil form for readability.
    # Fields are accessible via dot notation: date.year, time.hour, etc.
    date = ~D[2024-01-15]
    time = ~T[10:30:00]
    datetime = ~N[2024-01-15 10:30:00]

    IO.inspect(date, label: "date")
    IO.inspect(time, label: "time")
    IO.inspect(datetime, label: "naive datetime")
    IO.inspect(date.year, label: "year")
    IO.inspect(time.hour, label: "hour")

    # Snippet 4 — ~r flags and Regex.scan / named_captures
    # Flags go after the closing delimiter: i=case-insensitive, m=multiline, s=dotall, x=extended.
    # Regex.scan/2 returns all matches as a list of lists.
    # Named captures with (?<name>...) return a %{"name" => "value"} map.
    text = "Hello World\nhello elixir"

    matches = Regex.scan(~r/hello/i, text)
    IO.inspect(matches, label: "case-insensitive matches")

    ~r/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/
    |> Regex.named_captures("2024-01-15")
    |> IO.inspect(label: "named captures")

    IO.puts("\n" <> String.duplicate("--", 40))

    # Snippet 5 (continued) — using the custom ~l sigil with a heredoc delimiter
    # """ works as a delimiter for any sigil; useful for multiline content.
    # Blank lines and leading/trailing whitespace are stripped by sigil_l.
    lines = ~l"""
      apple
      banana

      cherry
    """

    IO.inspect(lines, label: "custom sigil lines")

    # Snippet 6 — sigil delimiters
    # Any paired delimiter works: / / ( ) [ ] { } | | ' ' " "
    # Pick the one that avoids escaping characters inside the sigil.
    # All three produce the same compiled regex — inspect normalises to slash form.
    IO.inspect(~r/hello/, label: "slash delimiter")
    IO.inspect(~r{hello}, label: "brace delimiter")
    IO.inspect(~r[hello], label: "bracket delimiter")

    # Practical example: use {} for URL regexes to avoid escaping forward slashes.
    path_regex = ~r{^/users/\d+/posts$}
    IO.inspect(Regex.match?(path_regex, "/users/42/posts"), label: "path match")
  end
end
