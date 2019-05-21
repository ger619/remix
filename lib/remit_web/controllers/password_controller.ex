defmodule RemitWeb.PasswordController do
  use RemitWeb, :controller

  alias Remit.Accounts
  alias Remit.PasswordChange

  def index(conn, _params) do
    changeset = %PasswordChange{} |> PasswordChange.changeset(%{})
    render(conn, "password_change.html", changeset: changeset)
  end

  def create(conn, %{"password_change" => params}) do
    user = conn.assigns.current_user.id |> Accounts.get_user!()

    case PasswordChange.update_password(params, user) do
      {:error, changeset} ->
        render(conn, "password_change.html", changeset: changeset)

      {:ok, _} ->
        conn
        |> put_flash(:info, "Your password has been updated.")
        |> redirect(to: Routes.page_path(conn, :dashboard))
    end
  end
end
 