defmodule Api.Account.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :service, :string
    field :currency, :string

    timestamps()
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:amount, :service, :currency])
    |> validate_required([:amount, :service, :currency])
  end
end
