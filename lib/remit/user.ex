defmodule Remit.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "users" do
    field :name, :string, null: false
    field :phone_number, :string, null: false
    field :email, :string
    field :id_number, :string
    field :id_type, :string
    field :deleted_at, :utc_datetime
    field :super_admin, :boolean, default: false
    field :require_password_change, :boolean, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :phone_number, :email, :id_number, :id_type, :super_admin])
    |> validate_required([
      :name,
      :phone_number,
      :email,
      :id_number,
      :id_type,
      :super_admin,
    ])
    |> unique_constraint(:phone_number)
  end

  def search_query(q) do
    search_query = "%#{q}%"

    from x in __MODULE__,
      where: ilike(x.name, ^search_query),
      or_where: ilike(x.id_number, ^search_query)
  end
end
