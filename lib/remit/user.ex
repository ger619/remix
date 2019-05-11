defmodule Remit.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Remit.Session

  schema "users" do
    field :name, :string, null: false
    field :phone_number, :string, null: false
    field :email, :string
    field :id_number, :string
    field :id_type, :string
    field :password_hash, :string
    field :deleted_at, :utc_datetime
    field :super_admin, :boolean, default: false
    field :require_password_change, :boolean, default: false
    has_many :sessions, Session, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :phone_number, :email, :id_number, :id_type, :password_hash])
    |> validate_required([:name, :phone_number, :email, :id_number, :id_type])
    |> unique_constraint(:phone_number)
    |> hash_password()
  end

  # If you are using Bcrypt or Pbkdf2, change Argon2 to Bcrypt or Pbkdf2
  defp hash_password(
         %Ecto.Changeset{valid?: true, changes: %{password_hash: password}} = changeset
       ) do
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  def search_query(q) do
    search_query = "%#{q}%"

    from x in __MODULE__,
      where: ilike(x.name, ^search_query),
      or_where: ilike(x.id_number, ^search_query)
  end
end
