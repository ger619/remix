defmodule Remit.UserProfiles  do
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
  def changeset(user__profile, attrs) do
    user__profile
    |> cast(attrs, [:role, :user_id, :profile_id])
    |> validate_required([:role, :profile_id, :user_id])
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert!()
  end

  def search_query(q) do
    q = "%#{q}%"
    from(u in __MODULE__,
      left_join: x in assoc(u, :user),
      left_join: y in assoc(u, :profile),
      preload: [user: x, profile: y],
      where: ilike(x.name, ^q),
      or_where: ilike(y.name, ^q)
      )
  end

  def join_user_query()  do
    from(u in __MODULE__,
    join: x in assoc(u, :user),
    join: y in assoc(u, :profile),
    preload: [user: x, profile: y])
  end

end
