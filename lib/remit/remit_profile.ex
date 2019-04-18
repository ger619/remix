defmodule Remit.Profile.Profile do
  alias Remit.Profile.Repo
  alias Remit.Profile

  def get_profile!(id), do: Repo.get!(Profile, id)

  def create(params) do
    Profile.changeset(%Profile{}, params)
    |> Repo.insert()
  end

  def update(profile, params) do
    __MODULE__
    |> Profile.changeset(profile, params)
    |> Repo.update()
  end
end
