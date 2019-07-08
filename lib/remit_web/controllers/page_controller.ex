defmodule RemitWeb.PageController do
  use RemitWeb, :controller

  alias Remit.{Repo, UserProfiles}

  def index(conn, _params) do

    render(conn, "index.html")
  end

  def dashboard(conn, params) do

    params = Map.get(params, "query", nil)

    query = case params do
      nil ->
        UserProfiles.join_user_query()
      query_string ->
        UserProfiles.search_query(query_string)
    end

    userprofiles = Repo.paginate(query)

    page = %Scrivener.Page{page_number: userprofiles.page_number,
    page_size: userprofiles.page_size,
    total_entries: userprofiles.total_entries,
    total_pages: userprofiles.total_pages}

    IO.inspect userprofiles

    conn
    |> render("dashboard.html",
    userprofiles: userprofiles.entries,
    page: page
    )
  end
end
