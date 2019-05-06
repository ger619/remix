defmodule Remit.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Remit.Repo
  alias Remit.Account
  alias Remit.Profile

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
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :phone_number, :email, :id_number, :id_type, :password_hash])
    |> validate_required([
      :name,
      :phone_number,
      :email,
      :id_number,
      :id_type,
      :password_hash
    ])
  end

  def search_query(q) do
    search_query = "%#{q}%"

    from x in __MODULE__,
      where: ilike(x.name, ^search_query),
      or_where: ilike(x.id_number, ^search_query)
  end

  def change_user() do
    %__MODULE__{} |> changeset(%{})
  end

  def create_user(params) do
   user = %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def get_user!(id), do: Repo.get!(User, id)

  def update_user(%__MODULE__{} = user, attrs) do
    user
    |> changeset(attrs)
    |> Repo.update()
  end

 # def create_account(user) do

  #end
end
