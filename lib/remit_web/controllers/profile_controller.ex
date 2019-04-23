defmodule RemitWeb.ProfileController do
  use RemitWeb, :controller

  alias Remit.Profile.Profile

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(_conn, _params) do
  end

  def edit(conn, %{"id" => id}) do
    profile = Profile.get_profile!(id)
    changeset = Remit.Profile.changeset(%Remit.Profile{}, %{})
    render(conn, "edit.html", changeset: changeset, profile: profile)
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = git Profile.get_profile!(id)

    case Profile.update_profile(profile, profile_params) do
      {:ok, profile} ->
        conn
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profile, changeset: changeset)
    end
  end
end
