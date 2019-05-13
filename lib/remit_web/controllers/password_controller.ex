defmodule RemitWeb.PasswordController do
  use RemitWeb, :controller

  alias Remit.PasswordChange

  def index(conn, _params) do
    changeset = %PasswordChange{} |> PasswordChange.changeset(%{})
    render(conn, "password_change.html", changeset: changeset)
  end

  def create(conn, %{"password_change" => params}) do
    user = conn.assigns.current_user

    case PasswordChange.update_password(params, user) do
      {:error, changeset} ->
        render(conn, "password_change.html", changeset: changeset)

      {:ok, _} ->
        conn
        |> put_flash(:info, "Success")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
