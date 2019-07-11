defmodule RemitWeb.PasswordController do
  use RemitWeb, :controller

  alias Remit.Accounts
  alias Remit.PasswordChange

  def index(conn, _params) do
    changeset = %PasswordChange{} |> PasswordChange.changeset(%{})
    render(conn, "password_change.html", changeset: changeset)
  end

  def create(conn, %{"password_change" => params}) do
    user = Accounts.get_user!(conn.assigns.current_user.id)

    case PasswordChange.update_password(user, params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Your password has been updated.")
        |> redirect(to: Routes.page_path(conn, :dashboard))

      {:error, changeset} ->
        render(conn, "password_change.html", changeset: changeset)
    end
  end
end
