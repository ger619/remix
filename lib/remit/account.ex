defmodule Remit.Account.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Remit.Repo
  alias Remit.User

  schema "accounts" do
    field :profile_id, :id
    field :credits, :decimal, default: 0
    field :debits, :decimal, default: 0
    field :balance, :decimal, default: 0
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end

  def create_account(user) do
    %__MODULE__{}
    |> Ecto.Changeset.change(%{user_id: user.id})
    |> Repo.insert()
  end
end
