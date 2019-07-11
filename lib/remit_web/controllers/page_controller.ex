defmodule RemitWeb.PageController do
  use RemitWeb, :controller

  alias Remit.{Repo, UserProfiles}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, params) do
    params = Map.get(params, "query", nil)

    query =
      case params do
        nil ->
          UserProfiles.join_user_query()

        query_string ->
          UserProfiles.search_query(query_string)
      end

    page = Repo.paginate(query)

    conn
    |> render("dashboard.html",
      user_profiles: page.entries,
      page: page
    )
  end
end
