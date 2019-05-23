defmodule Remit.UserProfiles  do
  use Ecto.Schema
  import Ecto.Changeset

  alias Remit.Repo

  schema "user_profiles" do
    field :role, :string
    field :user_id, :id
    field :profile_id, :id

    timestamps()
  end

  @doc false
  def changeset(user__profile, attrs) do
    user__profile
    |> cast(attrs, [:role, :user_id, :profile_id])
    |> validate_required([:role, :user_id, :profile_id])
    |> unique_constraint(:user_id)
    |> unique_constraint(:profile_id)
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert!()
  end
end
