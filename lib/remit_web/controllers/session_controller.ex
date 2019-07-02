defmodule RemitWeb.SessionController do
  use RemitWeb, :controller

  alias Phauxth.Remember
  alias Remit.Sessions.Sessionhandler
  alias Phauxth.Login

  # the following plug is defined in the controllers/authorize.ex file

  def new(conn, _) do
    render(conn, "index.html")
  end

  def create(conn, %{"session" => params}) do
    case Login.verify(params) do
      {:ok, user} ->
        conn
        |> add_session(user, params)
        |> put_flash(:info, "User successfully logged in.")
        |> redirect(to: get_session(conn, :request_path) || Routes.page_path(conn, :dashboard))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, %{"id" => session_id}) do
    if session = Sessionhandler.get_session(session_id) do
      Sessionhandler.delete_session(session)
    end

    conn
    |> delete_session(:phauxth_session_id)
    |> Remember.delete_rem_cookie()
    |> put_flash(:info, "User successfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def add_session(conn, user, params) do
    {:ok, %{id: session_id}} = Sessionhandler.create_session(%{user_id: user.id})

    conn
    |> delete_session(:request_path)
    |> put_session(:phauxth_session_id, session_id)
    |> configure_session(renew: true)
    |> add_remember_me(user.id, params)
  end

  # This function adds a remember_me cookie to the conn.
  # See the documentation for Phauxth.Remember for more details.
  defp add_remember_me(conn, user_id, %{"remember_me" => "true"}) do
    Remember.add_rem_cookie(conn, user_id)
  end

  defp add_remember_me(conn, _, _), do: conn
end
