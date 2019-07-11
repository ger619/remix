defmodule RemitWeb.UserControllerTest do
  use RemitWeb.ConnCase

  import Mox

  alias Remit.Repo
  alias Remit.Accounts

  @moduletag authenticate: %{email: "user@example.com"}

  @create_attrs %{
    email: "some@email.com",
    id_number: "some_id_number",
    id_type: "national_id",
    is_admin: "some_is_admin",
    name: "some_name",
    password_hash: "some_password_hash",
    phone_number: "some_phone_number"
  }
  @update_attrs %{
    email: "some@updatedemail.com",
    id_number: "some_updated_id_number",
    id_type: "national_id",
    is_admin: "some_updated_is_admin",
    name: "some_updated_name",
    password_hash: "some_updated_password_hash",
    phone_number: "some_updated_phone_number"
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
      |> expect(:deliver, fn phone_number, message, _config ->
        assert phone_number == @create_attrs.phone_number
        assert message =~ "Your new password is"
        {:ok, nil}
      end)

      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)
      assert get_flash(conn, :info) =~ "created"

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
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
      assert html_response(conn, 200) =~ "some@updatedemail.com"
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

  describe "reset password" do
    setup [:verify_on_exit!, :create_user]

    test "POST /users/:id/reset when require_password_change is true", %{conn: conn, user: user} do
      #line 139 has an error
      Remit.SMSMock
      |> expect(:deliver, fn phone_number, message, _config ->
        assert phone_number == @create_attrs.phone_number
        assert message =~ "Your new password is"
        {:ok, nil}
      end)

      conn = post(conn, Routes.user_path(conn, :reset_action, user))
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
      assert get_flash(conn, :info)
      assert %{require_password_change: true} = Accounts.get_user!(user.id)
    end

    test "POST /users/:id/reset when require_password_change is false", %{conn: conn, user: user} do
      user |> Ecto.Changeset.change(require_password_change: false) |> Repo.update!()
      conn = post(conn, Routes.user_path(conn, :reset_action, user))
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
      # assert get_flash(conn, :error)
      assert %{require_password_change: false} = Accounts.get_user!(user.id)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
