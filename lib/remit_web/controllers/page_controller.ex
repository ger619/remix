defmodule RemitWeb.PageController do
  use RemitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
