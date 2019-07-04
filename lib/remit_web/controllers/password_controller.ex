defmodule RemitWeb.PasswordController do
  use RemitWeb, :controller

  alias Remit.Accounts
  alias Remit.PasswordChange
  alias Remit.SMS

  # alias Remit.User

  def index(conn, _params) do
    changeset = %PasswordChange{} |> PasswordChange.changeset(%{})
    render(conn, "password_change.html", changeset: changeset)
  end

  defp random_pass(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  def create(conn, %{"password_change" => params}) do
    user = conn.assigns.current_user.id |> Accounts.get_user!()
    password = random_pass(6)
    params = Map.put(params, "password_hash", password)

    case PasswordChange.update_password(params, user) do
      {:ok, _} ->
        SMS.deliver(
          user.phone_number,
          "Your new password is #{password} logon to #{Routes.page_url(conn, :index)} to change it"
        )

        conn
        |> put_flash(:info, "Your password has been updated.")
        |> redirect(to: Routes.page_path(conn, :dashboard))

      {:error, changeset} ->
        render(conn, "password_change.html", changeset: changeset)
    end
  end
end
