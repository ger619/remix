defmodule RemitWeb.PageController do
  use RemitWeb, :controller

  alias Remit.{Repo, UserProfiles}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, params) do
    term = Map.get(params, "query", nil)

    query =
      UserProfiles.user_query(conn.assigns.current_user.id)
      |> UserProfiles.preload_profile_query()

    query =
      case term do
        nil ->
          query

        q ->
          UserProfiles.search_query(query, q)
      end

    page = Repo.paginate(query)

    conn
    |> render("dashboard.html",
      page: page
    )
  end
end
