defmodule RemitWeb.ProfileController do
  use RemitWeb, :controller

  alias Remit.Profile

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
  end

  def edit(conn, %{"id" => id} = _prams) do
    profile = Profile.get_by_id!(id)

    changeset = Profile.changeset(Profile, %{})

    render(conn, "edit.html", changeset: changeset, profile: profile)
  end

  def update(conn, %{"profile" => profile_params}) do
    profile = Profile.get_profile(profile_params)

    case Profile.update_profile(profile, profile_params) do
      {:ok, profile} ->
        conn
        |> redirect(to: Routes.profiles_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profile, changeset: changeset)
    end
  end
end
