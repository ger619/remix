defmodule RemitWeb.ProfileController do
  use RemitWeb, :controller

  alias Remit.Profile

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Profile.changeset(%Profile{})
    render conn, "new.html", changeset: changeset
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
end
