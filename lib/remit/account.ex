defmodule Remit.Account.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :profile_id, :id
    field :credits, :decimal, default: 0
    field :debits, :decimal, default: 0
    field :balance, :decimal, default: 0

    timestamps()
  end

  @doc false
  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:profile_id])
    |> validate_required([:profile_id])
  end
end
