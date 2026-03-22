defmodule ElixirBasics.Lessons.Ecto do
  defmodule User do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:name, :string)
      field(:email, :string)
      field(:age, :integer)
    end

    def changeset(user \\ %User{}, params) do
      user
      |> cast(params, [:name, :email, :age])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
      |> validate_number(:age, greater_than: 0)
    end
  end

  def run do
    valid = User.changeset(%{name: "Ritesh", email: "r@example.com", age: 30})
    invalid = User.changeset(%{name: "Bob", email: "not-an-email", age: -1})

    IO.inspect(valid.valid?, label: "valid?")
    IO.inspect(valid.changes, label: "changes")
    IO.inspect(invalid.errors, label: "errors")
    {:ok, user} = Ecto.Changeset.apply_action(valid, :insert)
    IO.inspect(user, label: "user struct")

    updated = User.changeset(user, %{age: 31})
    {:ok, updated_user} = Ecto.Changeset.apply_action(updated, :update)
    IO.inspect(updated_user, label: "updated")
  end
end
