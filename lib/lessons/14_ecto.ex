defmodule ElixirBasics.Lessons.Ecto do
  defmodule User do
    use Ecto.Schema
    import Ecto.Changeset

    # ── embedded_schema ─────────────────────────────────────────────────
    # An embedded schema defines typed fields WITHOUT a database table.
    # Useful for validating data from forms, APIs, or config — no DB needed.
    # Ecto automatically adds an :id field (UUID by default).
    embedded_schema do
      field(:name, :string)
      field(:email, :string)
      field(:age, :integer)
    end

    # ── changeset/2 ─────────────────────────────────────────────────────
    # A changeset is a data structure that tracks:
    #   - which fields changed (changes)
    #   - whether the data is valid (valid?)
    #   - what errors were found (errors)
    # It does NOT modify the struct directly — call apply_action/2 for that.
    def changeset(user \\ %User{}, params) do
      user
      # cast/3 — pull allowed fields from the raw map and coerce types
      |> cast(params, [:name, :email, :age])
      # validate_required — mark fields that must be present and non-nil
      |> validate_required([:name, :email])
      # validate_format — check the value matches a regex
      |> validate_format(:email, ~r/@/)
      # validate_number — check numeric constraints
      |> validate_number(:age, greater_than: 0)
    end
  end

  def run do
    # ── Building changesets ──────────────────────────────────────────────
    # Pass raw params (from a form, JSON, etc.) — changeset coerces and validates.
    valid = User.changeset(%{name: "Ritesh", email: "r@example.com", age: 30})
    invalid = User.changeset(%{name: "Bob", email: "not-an-email", age: -1})

    # true
    IO.inspect(valid.valid?, label: "valid?")
    # all fields (none existed before)
    IO.inspect(valid.changes, label: "changes")
    # [{:email, ...}, {:age, ...}]
    IO.inspect(invalid.errors, label: "errors")

    # ── Applying a changeset ─────────────────────────────────────────────
    # apply_action/2 finalises the changeset and returns the struct, OR
    # returns {:error, changeset} if validation failed.
    # :insert / :update are just labels — they don't trigger any DB action here.
    {:ok, user} = Ecto.Changeset.apply_action(valid, :insert)
    IO.inspect(user, label: "user struct")

    # ── Changeset as diff ────────────────────────────────────────────────
    # Passing an existing struct as the first arg tracks ONLY what changed.
    # Here only :age changes — name and email stay the same, so they won't
    # appear in the changeset's `changes` map.
    updated = User.changeset(user, %{age: 31})
    {:ok, updated_user} = Ecto.Changeset.apply_action(updated, :update)
    IO.inspect(updated_user, label: "updated")
  end
end
