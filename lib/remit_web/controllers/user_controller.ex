defmodule RemitWeb.UserController do
  use RemitWeb, :controller

  alias Phauxth.Log
  alias Remit.Repo
  alias Remit.User
  alias Remit.Accounts
  alias RemitWeb.Auth.Token

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
      {:ok, %User{phone_number: phone_number} = user} ->
        Log.info(%Log{user: user.id, message: "user created"})
        key = Token.sign(%{"phone_number" => phone_number})
        Phone_number.confirm_request(phone_number, key)

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    user = if id == to_string(user.id), do: user, else: Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def edit(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  # def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
  #   {:ok, _user} = Accounts.delete_user(user)
  #
  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: Routes.session_path(conn, :new))
  # end
end
