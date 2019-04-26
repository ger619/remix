defmodule Remit.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Remit.Repo

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

  def create_user(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def search_query(q) do

    search_query = "%#{q}%"
    from u in __MODULE__, where: ilike(u.name, ^search_query), or_where: ilike(u.id_number, ^search_query)

  end
end
