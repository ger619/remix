defmodule Remit.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Remit.Repo
  alias Remit.Session
  alias Remit.Profile

  schema "users" do
    field :name, :string, null: false
    field :phone_number, :string, null: false
    field :email, :string
    field :id_number, :string
    field :id_type, :string
    field :password_hash
    field :deleted_at, :utc_datetime
    field :super_admin, :boolean, default: false
    field :require_password_change, :boolean, default: false
    has_many :sessions, Session, on_delete: :delete_all

    many_to_many(
      :profiles,
      Profile,
      join_through: "user_profiles",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :phone_number,
      :email,
      :id_number,
      :id_type,
      :super_admin,
      :password_hash
    ])
    |> validate_required([:name, :phone_number, :email, :id_number, :id_type])
    |> unique_constraint(:phone_number)
    |> validate_format(:email, ~r/@/)
    |> password_hash()
  end

  defp password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password_hash: password}} = changeset
       ) do
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp password_hash(changeset) do
    changeset
  end

  def search_query(q) do
    search_query = "%#{q}%"

    from x in __MODULE__,
      where: ilike(x.name, ^search_query),
      or_where: ilike(x.id_number, ^search_query)
  end

  def get_user!(id), do: Repo.get!(__MODULE__, id)

  def set_require_password_change(user = %{require_password_change: true}, new_password) do
    user =
      user
      |> change(%{require_password_change: true, password_hash: new_password})
      |> password_hash()
      |> Repo.update!()

    {:ok, user}
  end

  def set_require_password_change(_, _) do
    {:error, :already_reset}
  end
end
