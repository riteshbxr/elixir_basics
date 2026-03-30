defmodule ElixirBasics.Lessons.Structs do
  # ── Struct with default values ─────────────────────────────────────────
  # defstruct defines a struct inside a module. The module name becomes the type.
  # Fields listed as key: default — missing fields get the default at creation time.
  defmodule User do
    defstruct name: "Anonymous",
              age: 0,
              role: :guest
  end

  # ── Struct with enforced keys ──────────────────────────────────────────
  # @enforce_keys raises a compile-time error if those fields are missing
  # when creating the struct. Mix of enforced (:title, :body — no default)
  # and optional (status, views — have defaults) fields.
  defmodule Post do
    @enforce_keys [:title, :body]
    defstruct [:title, :body, status: :draft, views: 0]

    # Constructor convention — named `new/2`, hides the struct literal
    def new(title, body) do
      %Post{title: title, body: body}
    end
  end

  # ── Pattern matching on struct fields ─────────────────────────────────
  # Elixir checks the most specific clause first (top-to-bottom).
  # The first clause only matches User structs whose role field is :admin.
  def greet(%User{name: name, role: :admin}), do: "Welcome back, admin #{name}!"
  def greet(%User{name: name}), do: "Hello, #{name}."   # catches all other Users

  # ── Binding the whole struct while matching a field ───────────────────
  # `user = %User{}` matches any User struct AND binds the whole struct to `user`.
  # This lets you use `user` inside the function body without re-fetching it.
  def promote(user = %User{}) do
    %{user | role: :admin}    # update syntax — returns a new struct
  end

  def run() do
    IO.puts(String.duplicate("---", 20))

    # ── Creating and updating a Post ──────────────────────────────────────
    p = Post.new("Hello Elixir", "My first post")
    IO.puts(inspect(p))
    IO.puts(p.status)   # dot syntax to access a field

    # %{struct | field: new_value} — same syntax as maps, returns new struct
    published = %{p | status: :published}
    IO.puts(published.status)

    IO.puts(String.duplicate("---", 20))

    # ── Struct polymorphism via pattern-matched function clauses ───────────
    guest = %User{name: "Bob"}
    admin = promote(guest)          # returns a new User with role: :admin
    IO.puts("Bob Promoted: " <> greet(admin))

    u1 = %User{}                           # uses all defaults
    u2 = %User{name: "Ritesh", age: 30, role: :admin}
    IO.puts("u2: " <> greet(u2))
    IO.puts("u1: " <> greet(u1))
    IO.puts(String.duplicate("---", 20))

    IO.puts(inspect(u1))
    IO.puts(inspect(u2))
    IO.puts(u2.name)

    # Structs are updated the same way as maps — immutable, returns new value
    u3 = %{u2 | age: 31}
    IO.puts("updated age: #{u3.age}")
  end
end
