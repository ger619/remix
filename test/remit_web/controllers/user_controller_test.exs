defmodule RemitWeb.UserControllerTest do
  use RemitWeb.ConnCase

  test "GET /users", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :index))
    assert html_response(conn, 200)
  end

  test "GET /users?query=a&page=2", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :index))
    assert html_response(conn, 200)
  end
end
