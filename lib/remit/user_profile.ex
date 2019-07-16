defmodule Remit.UserProfiles do
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Remit.{User, Profile, Repo}

  schema "user_profiles" do
    field :role, :string
    belongs_to(:user, User)
    belongs_to(:profile, Profile)

    timestamps()
  end

  @doc false
  def changeset(user_profile, attrs) do
    user_profile
    |> cast(attrs, [:role, :user_id, :profile_id])
    |> validate_required([:role, :profile_id, :user_id])
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert!()
  end

  def preload_profile_query(queryable \\ __MODULE__) do
    from(u in queryable,
      join: p in assoc(u, :profile),
      as: :profile,
      preload: [profile: p]
    )
  end

  @doc """
  Search for associated profile by name

  Assumes profile is joined in
  """
  def search_query(queryable \\ __MODULE__, q) do
    q = "%#{q}%"

    from([profile: p] in queryable,
      where: ilike(p.name, ^q)
    )
  end

  def join_user_query() do
    from(u in __MODULE__,
      join: x in assoc(u, :user),
      join: y in assoc(u, :profile),
      preload: [user: x, profile: y]
    )
  end

  def user_query(queryable \\ __MODULE__, user_id) do
    from(u in queryable, where: u.user_id == ^user_id)
  end
end
