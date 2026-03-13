defmodule ElixirBasics.Lessons.Structs do
  defmodule User do
    defstruct name: "Anonymous",
              age: 0,
              role: :guest
  end

  defmodule Post do
    @enforce_keys [:title, :body]
    defstruct [:title, :body, status: :draft, views: 0]

    def new(title, body) do
      %Post{title: title, body: body}
    end
  end

  def greet(%User{name: name, role: :admin}), do: "Welcome back, admin #{name}!"
  def greet(%User{name: name}), do: "Hello, #{name}."

  def promote(user = %User{}) do
    %{user | role: :admin}
  end

  def run() do
    IO.puts(String.duplicate("---", 20))
    p = Post.new("Hello Elixir", "My first post")
    IO.puts(inspect(p))
    IO.puts(p.status)

    published = %{p | status: :published}
    IO.puts(published.status)

    IO.puts(String.duplicate("---", 20))

    guest = %User{name: "Bob"}
    admin = promote(guest)
    IO.puts("Bob Promoted: " <> greet(admin))

    u1 = %User{}
    u2 = %User{name: "Ritesh", age: 30, role: :admin}
    IO.puts("u2: " <> greet(u2))
    IO.puts("u1: " <> greet(u1))
    IO.puts(String.duplicate("---", 20))

    IO.puts(inspect(u1))
    IO.puts(inspect(u2))
    IO.puts(u2.name)

    # Update like a map
    u3 = %{u2 | age: 31}
    IO.puts("updated age: #{u3.age}")
  end
end
