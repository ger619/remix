defmodule Remit.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Remit.Repo

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
    |> cast(attrs, [])
    |> validate_required([])
  end

  def create_account(user) do
    %__MODULE__{}
    |> Ecto.Changeset.change(%{user_id: user.id})
    |> Repo.insert()
  end
end
