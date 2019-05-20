defmodule RemitWeb.UserController do
  use RemitWeb, :controller

  alias Remit.Repo
  alias Remit.User
  alias Remit.Accounts

  def index(conn, params) do
    page =
      case params["query"] do
        nil ->
          User

        term ->
          User.search_query(term)
      end
      |> Repo.paginate(params)

    render(conn, "index.html", users: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp random_pass(25) do
    :crypto.strong_rand_bytes(25) |> Base.url_encode64() |> binary_part(0, 25)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    changeset = Accounts.change_user(user)

    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => user_id, "user" => user_params}) do
    user = Accounts.get_user!(user_id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => user_id}) do
    user =
      Accounts.get_user!(user_id)
      |> Accounts.delete_user!()

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :show, user))
  end

  def reset_action(conn, %{"id" => user_id}) do
    user = Account.get_user!(user_id)
    pass = random_pass(25)

    case User.set_require_password_change(user, pass) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Your password has been reset")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, _} ->
        conn
        |> put_flash(:info, "Password has been resent")
        |> redirect(to: Routes.user_path(conn, :show, user))
    end
  end
end
