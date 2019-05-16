defmodule RemitWeb.UserControllerTest do
  use RemitWeb.ConnCase

  import Mox

  alias Remit.Repo
  alias Remit.Accounts
  alias Remit.IDType

  @moduletag authenticate: %{email: "user@example.com"}

  @create_attrs %{
    email: "some email",
    id_number: "some id_number",
    id_type: "national_id",
    is_admin: "some is_admin",
    name: "some name",
    password_hash: "some password_hash",
    phone_number: "some phone_number"
  }
  @update_attrs %{
    email: "some updated email",
    id_number: "some updated id_number",
    id_type: "national_id",
    is_admin: "some updated is_admin",
    name: "some updated name",
    password_hash: "some updated password_hash",
    phone_number: "some updated phone_number"
  }
  @invalid_attrs %{
    email: nil,
    id_number: nil,
    id_type: nil,
    is_admin: nil,
    name: nil,
    password_hash: nil,
    phone_number: nil
  }

  def fixture(:user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    Repo.insert!(
      %Remit.IDType{
        slug: @create_attrs.id_type,
        name: "National ID",
        inserted_at: now,
        updated_at: now
      },
      on_conflict: :nothing
    )

    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    setup :verify_on_exit!

    test "redirects to show when data is valid", %{conn: conn} do
      Remit.SMSMock
      |> expect(:deliver, fn _msisdn, _message, _config -> {:ok, :sent} end)

      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      id_types =  IDType.all() |> Enum.map(fn [a, b] -> ({a, b}) end)
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      # user is still shown when archived
      assert html_response(conn, 200)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
