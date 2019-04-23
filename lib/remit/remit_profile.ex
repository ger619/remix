defmodule Remit.Profile.Profile do
  alias Remit.Repo
  alias Remit.Profile

  def get_profile!(id), do: Repo.get!(Profile, id)

  def create(params) do
    Profile.changeset(%Profile{}, params)
    |> Repo.insert()
  end

  def update_profile(%Profile{} = profile, params) do
    profile
    |> Profile.changeset(params)
    |> Repo.update()
  end
end
