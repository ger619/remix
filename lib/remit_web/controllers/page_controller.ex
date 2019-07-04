defmodule RemitWeb.PageController do
  use RemitWeb, :controller

  alias Remit.{Profile, Repo, UserProfiles}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, params) do

    userprofiles = Repo.all(UserProfiles)
    |> Repo.preload([:user, :profile])

    search_term = get_in(params, ["query"])
    Profile
    |> Profile.search(search_term)
    |> Repo.all()

    render(conn, "dashboard.html", userprofiles: userprofiles)
  end
end
