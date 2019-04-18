defmodule Remit.Account.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :profile_id, :id
    field :credits, :decimal
    field :debits, :decimal
    field :balance, :decimal

    timestamps()
  end

  @doc false
  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:profile_id, :credit, :debits, :balance])
    |> validate_required([:profile_id, :credit, :debits, :balance])
  end
end
