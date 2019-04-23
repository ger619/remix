defmodule RemitWeb.ProfileController do
  use RemitWeb, :controller

  alias Remit.Repo
  alias Remit.Profile

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Profile.changeset(%Profile{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"profile" => profile_params}) do
    case Profile.create(profile_params) do
      {:ok, profile} ->
        conn
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    changeset = Profile.changeset(%Profile{}, %{})
    render(conn, "edit.html", changeset: changeset, profile: profile)
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Repo.get!(Profile, id)

    case Profile.update_profile(profile, profile_params) do
      {:ok, profile} ->
        conn
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profile, changeset: changeset)
    end
  end
end
