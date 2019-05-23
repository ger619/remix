defmodule RemitWeb.PageController do
  use RemitWeb, :controller


  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params) do
    render(conn, "dashboard.html")
  end
end
