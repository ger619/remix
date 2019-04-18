defmodule Remit.Profile.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string, null: false
    field :phone_number, :string, null: false
    field :email, :string
    field :id_number, :string
    field :id_type, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :phone_number, :id_number, :id_type])
    |> validate_required([:name, :phone_number, :id_number, :id_type])
  end
end
