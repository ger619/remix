defmodule RemitWeb.PassWordControllerTest do
  #use ExUnit.Case
  use RemitWeb.ConnCase

    test "GET /password/", %{conn: conn} do
      conn = get(conn, Routes.password_path(conn, :index))
      assert html_response(conn, 200)
    end
end
