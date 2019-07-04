defmodule Remit.UserProfiles  do
  use Ecto.Schema
  import Ecto.Changeset

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
end
