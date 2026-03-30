defmodule ElixirBasics.Lessons.EctoSQLite do
  # ── Repo ────────────────────────────────────────────────────────────────
  # Repo is the gateway to the database. Every DB operation goes through it.
  # otp_app: tells Ecto where to look for config (our app name).
  # adapter: selects the database driver — SQLite3 here.
  defmodule Repo do
    use Ecto.Repo,
      otp_app: :elixir_basics,
      adapter: Ecto.Adapters.SQLite3
  end

  # ── Schema ──────────────────────────────────────────────────────────────
  # `schema "users"` maps this module to a real database table named "users".
  # Unlike embedded_schema (lesson 14), this requires an actual table to exist.
  # timestamps() automatically adds inserted_at and updated_at columns.
  defmodule User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field(:name, :string)
      field(:email, :string)
      field(:age, :integer)
      timestamps()    # adds inserted_at and updated_at, managed by Ecto
    end

    # ── Changeset ──────────────────────────────────────────────────────
    # When user \\ %User{} is a new struct: all fields are "changes" (insert mode).
    # When user is an existing loaded struct: only diffs are "changes" (update mode).
    def changeset(user \\ %User{}, params) do
      user
      |> cast(params, [:name, :age, :email])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
    end
  end

  # ── Migration ───────────────────────────────────────────────────────────
  # Migrations define how to create/alter/drop tables.
  # Normally these live in priv/repo/migrations/ — here we define inline
  # so the whole lesson is self-contained in one file.
  # change/0 is called by Ecto.Migrator — creates the table when run :up.
  defmodule Migration0 do
    use Ecto.Migration

    def change do
      create table(:users) do
        add(:name, :string, null: false)    # NOT NULL in the DB
        add(:email, :string, null: false)
        add(:age, :integer)                 # nullable
        timestamps()                        # inserted_at, updated_at columns
      end
    end
  end

  def run do
    # ── Start the Repo ─────────────────────────────────────────────────
    # database: ":memory:" — SQLite in-memory DB, lives only for this process.
    # pool_size: 1 is REQUIRED for in-memory SQLite: each connection in the pool
    # gets its own separate in-memory database, causing "table not found" errors.
    # Use a file path like "/tmp/elixir_basics.db" for persistence (pool_size not needed).
    {:ok, _} = Repo.start_link(database: ":memory:", pool_size: 1)

    # ── Run the migration ──────────────────────────────────────────────
    # [{version, module}] — version 0 maps to our Migration0 module.
    # :up runs change/0. all: true runs every migration not yet applied.
    # Ecto tracks applied migrations in the schema_migrations table.
    Ecto.Migrator.run(Repo, [{0, Migration0}], :up, all: true)
    IO.puts("Repo started and migration complete")

    # ── Insert ────────────────────────────────────────────────────────
    # Repo.insert!/1 takes a changeset, validates, and writes to the DB.
    # Returns the persisted struct with :id, :inserted_at, :updated_at filled in.
    alice =
      User.changeset(%{name: "Alice", email: "alice@example.com", age: 30})
      |> Repo.insert!()

    IO.inspect(alice, label: "inserted")
    IO.puts(String.duplicate("---", 40))

    # ── Query ─────────────────────────────────────────────────────────
    # import Ecto.Query brings `from` into scope — the query building macro.
    # from(u in User, where: u.age >= 18) builds a composable query struct.
    # Repo.all/1 executes it and returns a list of structs.
    import Ecto.Query

    users = Repo.all(from(u in User, where: u.age >= 18))
    IO.inspect(users, label: "adults")

    # Repo.get/2 — fetch by primary key, returns struct or nil
    found = Repo.get(User, alice.id)
    IO.inspect(found, label: "get by id")

    IO.puts(String.duplicate("---", 40))

    # ── Update ────────────────────────────────────────────────────────
    # Pass the existing struct as first arg — changeset diffs against it.
    # Ecto only sends changed fields in the UPDATE SQL (e.g. SET age = 31).
    updated_alice =
      User.changeset(alice, %{age: 31})
      |> Repo.update!()

    IO.inspect(updated_alice, label: "updated")

    # ── Delete ────────────────────────────────────────────────────────
    # Repo.delete!/1 deletes the row identified by the struct's primary key.
    Repo.delete!(updated_alice)
    IO.puts("Alice deleted")

    # Repo.all(User) without a query is shorthand for Repo.all(from u in User)
    remaining = Repo.all(User)
    IO.inspect(remaining, label: "remaining users")
  end
end
