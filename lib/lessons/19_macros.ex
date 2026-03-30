defmodule ElixirBasics.Lessons.Macros do
  # Snippet 2 — defmacro: writing a macro
  # Macros receive AST as arguments and must return AST.
  # quote/1 freezes code as AST; unquote/1 injects caller values into that AST.
  # Without unquote, `condition` would refer to the variable inside the macro, not the caller's expression.
  # Pattern matching on `do: block` extracts the do-block from keyword syntax.
  defmacro my_unless(condition, do: block) do
    quote do
      if !unquote(condition) do
        unquote(block)
      end
    end
  end

  # Snippet 3 — __using__ and use
  # `use Foo` calls `Foo.__using__/1` and injects the returned AST into the calling module.
  # opts is a keyword list — anything passed after the module name: `use Greeter, lang: :spanish`.
  # unquote(default_lang) runs at compile time, baking the option value into each module.
  defmodule Greeter do
    defmacro __using__(opts) do
      default_lang = Keyword.get(opts, :lang, :english)

      quote do
        def greet(name) do
          case unquote(default_lang) do
            :english -> "Hello, #{name}!"
            :spanish -> "Hola, #{name}!"
          end
        end
      end
    end
  end

  # Snippet 4 — @before_compile and module attribute accumulation
  # @before_compile registers a hook that fires after the module body finishes compiling.
  # Module attributes (@routes) can accumulate state as each macro call fires.
  # Each `get` macro prepends to @routes (hence reverse order in output).
  # __before_compile__/1 generates the `routes/0` function from the accumulated list.
  # This is the same pattern Phoenix uses internally to build its router.
  defmodule Router do
    defmacro __using__(_opts) do
      quote do
        import Router
        @routes []
        @before_compile Router
      end
    end

    defmacro get(path, handler) do
      quote do
        @routes [{:get, unquote(path), unquote(handler)} | @routes]
      end
    end

    defmacro __before_compile__(_env) do
      quote do
        def routes, do: @routes
      end
    end
  end

  # Snippet 5 — defmacrop (private macro)
  # defmacrop is like defp — only callable within this module.
  # Macro.to_string(expr) runs at compile time, capturing the source text of the expression.
  # The result is a transparent debug wrapper: prints "expr = value" and returns the value.
  defmacrop debug(expr) do
    quote do
      result = unquote(expr)
      IO.puts("#{unquote(Macro.to_string(expr))} = #{inspect(result)}")
      result
    end
  end

  def run do
    IO.puts("=== Step 19: Macros & use ===\n")

    # Snippet 1 — quote and the AST
    # Every Elixir expression is a 3-tuple: {operator, metadata, arguments}.
    # quote/1 returns this tuple without evaluating the expression.
    # This is the data structure macros receive and must return.
    ast = quote do: 1 + 2
    IO.inspect(ast, label: "AST of 1 + 2")

    ast2 = quote do: String.upcase("hello")
    IO.inspect(ast2, label: "AST of String.upcase")

    IO.puts("\n-- my_unless macro --")
    # my_unless expands to `if !condition do block end` at compile time — zero runtime overhead.
    my_unless 2 > 10 do
      IO.puts("2 is not greater than 10")
    end

    IO.puts("\n-- use and __using__ --")
    # use Greeter injects a greet/1 function into EnglishBot with :english baked in.
    # use Greeter, lang: :spanish injects the same function but with :spanish baked in.
    defmodule EnglishBot do
      use Greeter
    end

    defmodule SpanishBot do
      use Greeter, lang: :spanish
    end

    IO.puts(EnglishBot.greet("Ritesh"))
    IO.puts(SpanishBot.greet("Ritesh"))

    IO.puts("\n-- @before_compile: route accumulation --")
    # Each get/2 call appends to @routes at compile time.
    # After the module body, @before_compile fires and generates routes/0 from the accumulated list.
    defmodule MyApp.Router do
      use Router
      get("/users", :list_users)
      get("/posts", :list_posts)
    end

    IO.inspect(MyApp.Router.routes(), label: "routes")

    IO.puts("\n-- Macro.expand --")
    # Macro.to_string/1 converts an AST back to readable source — useful for debugging macros.
    # Note: it pretty-prints the AST as given; it does not recursively expand nested macros.
    expanded =
      Macro.to_string(
        quote do
          unless true do
            IO.puts("nope")
          end
        end
      )

    IO.puts("unless expands to: #{expanded}")

    IO.puts("\n-- defmacrop: private macro --")
    # debug/1 is a private macro — Macro.to_string runs at compile time, not runtime.
    # The expression source text is captured as a string literal in the generated code.
    debug(1 + 2)
    debug(String.upcase("hello"))
  end
end
