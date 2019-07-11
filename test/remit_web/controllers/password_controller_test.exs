defmodule RemitWeb.PassWordControllerTest do
  use RemitWeb.ConnCase

  alias Remit.Repo
  alias Remit.User

  @moduletag authenticate: %{
               email: "test@example.com",
               password_hash: Bcrypt.hash_pwd_salt("admin123")
             }

  test "GET /password-change", %{conn: conn} do
    conn = get(conn, Routes.password_path(conn, :index))
    assert html_response(conn, 200)
  end

  test "POST /password-change when valid", %{conn: conn} do
    Repo.get_by!(User, email: "test@example.com")
    |> Ecto.Changeset.change(require_password_change: true)
    |> Repo.update!()

    conn =
      post(conn, Routes.password_path(conn, :create), %{
        "password_change" => %{
          "current_password" => "admin123",
          "password" => "abc456",
          "password_confirmation" => "abc456"
        }
      })

    assert redirected_to(conn) == Routes.page_path(conn, :dashboard)
    user = Repo.get_by!(User, email: "test@example.com")
    assert %{require_password_change: false} = user
    assert Bcrypt.verify_pass("abc456", user.password_hash)
  end

  test "POST /password-change when invalid", %{conn: conn} do
    conn =
      post(conn, Routes.password_path(conn, :create), %{
        "password_change" => %{
          "current_password" => "admin123",
          "password" => "abc456",
          "password_confirmation" => "abc123"
        }
      })

    assert html_response(conn, 200)
  end

  test "POST /password-change when current password doenst match", %{conn: conn} do
    conn =
      post(conn, Routes.password_path(conn, :create), %{
        "password_change" => %{
          "current_password" => "wrong",
          "password" => "abc123",
          "password_confirmation" => "abc123"
        }
      })

    assert html_response(conn, 200)
  end
end
