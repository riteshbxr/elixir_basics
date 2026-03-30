defmodule ElixirBasics.Lessons.Protocols do
  # ── Defining a protocol ────────────────────────────────────────────────
  # defprotocol declares a set of functions with no implementation.
  # Each data type gets its own implementation via defimpl.
  # Dispatch is automatic — Elixir picks the right impl based on the value's type.
  defprotocol Describable do
    # t() is a special type alias meaning "the type being implemented for"
    @spec describe(t()) :: String.t()
    def describe(value)

    # @fallback_to_any true allows a generic `for: Any` impl as a default.
    # Without this, calling describe on an unimplemented type raises Protocol.UndefinedError.
    @fallback_to_any true
  end

  # ── Fallback implementation ────────────────────────────────────────────
  # `for: Any` is the catch-all — only used when no specific impl matches.
  defimpl Describable, for: Any do
    def describe(value), do: "Unknown: #{inspect(value)}"
  end

  # ── Implementing for multiple types at once ────────────────────────────
  # Pass a list to `for:` to share one implementation across several types.
  defimpl Describable, for: [Integer, Float] do
    def describe(n), do: "Number #{n}"
  end

  # ── Implementing for a built-in type ──────────────────────────────────
  # Strings in Elixir are `BitString` internally (not "String").
  defimpl Describable, for: BitString do
    def describe(s), do: "String: \"#{s}\""
  end

  # ── Custom struct ─────────────────────────────────────────────────────
  defmodule Color do
    defstruct [:r, :g, :b]
  end

  # ── Implementing for your own struct ──────────────────────────────────
  # `for: Color` — Elixir matches on the struct's module name as the type.
  defimpl Describable, for: Color do
    def describe(%Color{r: r, g: g, b: b}), do: "Color(#{r}, #{g}, #{b})"
  end

  # ── Plugging into Elixir's built-in String.Chars protocol ─────────────
  # String.Chars is what powers #{...} interpolation.
  # Implementing to_string/1 for Color makes `"#{color}"` work automatically.
  defimpl String.Chars, for: Color do
    def to_string(%Color{r: r, g: g, b: b}), do: "rgb(#{r},#{g},#{b})"
  end

  def run do
    IO.puts(Describable.describe(42))          # Integer impl
    IO.puts(Describable.describe(42.12))       # Float impl (same as Integer)
    IO.puts(Describable.describe("hello"))     # BitString impl
    color = %Color{r: 255, g: 0, b: 0}
    IO.puts(Describable.describe(color))       # Color impl
    IO.puts(Describable.describe([1, 2, 3]))   # Any fallback (no List impl)

    # String.Chars impl — #{color} calls Color's to_string/1
    IO.puts("My Color is: #{color}")
  end
end
