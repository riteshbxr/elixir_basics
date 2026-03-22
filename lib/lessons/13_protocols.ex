defmodule ElixirBasics.Lessons.Protocols do
  defprotocol Describable do
    @spec describe(t()) :: String.t()
    def describe(value)

    @fallback_to_any true
  end

  defimpl Describable, for: Any do
    def describe(value), do: "Unknown: #{inspect(value)}"
  end

  defimpl Describable, for: [Integer, Float] do
    def describe(n), do: "Number #{n}"
  end

  defimpl Describable, for: BitString do
    def describe(s), do: "String: \"#{s}\""
  end

  defmodule Color do
    defstruct [:r, :g, :b]
  end

  defimpl Describable, for: Color do
    def describe(%Color{r: r, g: g, b: b}), do: "Color(#{r}, #{g}, #{b})"
  end

  # -------
  defimpl String.Chars, for: Color do
    def to_string(%Color{r: r, g: g, b: b}), do: "rgb(#{r},#{g},#{b})"
  end

  def run do
    IO.puts(Describable.describe(42))
    IO.puts(Describable.describe(42.12))
    IO.puts(Describable.describe("hello"))
    color = %Color{r: 255, g: 0, b: 0}
    IO.puts(Describable.describe(color))
    IO.puts(Describable.describe([1, 2, 3]))

    IO.puts("My Color is: #{color}")
  end
end
