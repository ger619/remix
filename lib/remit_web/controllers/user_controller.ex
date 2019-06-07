defmodule RemitWeb.UserController do
  use RemitWeb, :controller

  alias Remit.{Repo, User, Accounts, IDType, SMS}

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
    id_types = IDType.all()
    render(conn, "new.html", changeset: changeset, id_types: id_types)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    password = random_pass(6)
    Map.merge(user_params, %{"password_hash" => password})

    case Accounts.create_user(user_params) do
      {:ok, user} ->
        SMS.deliver(
          user.phone_number,
          "Your new password is #{password} logon to http://… to change it"
        )

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        id_types = IDType.all()
        render(conn, "new.html", changeset: changeset, id_types: id_types)
    end
  end

  defp random_pass(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    changeset = Accounts.change_user(user)
    id_types = IDType.all()
    render(conn, "edit.html", user: user, id_types: id_types, changeset: changeset)
  end

  def update(conn, %{"id" => user_id, "user" => user_params}) do
    user = Accounts.get_user!(user_id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        id_types = IDType.all()
        render(conn, "edit.html", user: user, id_types: id_types, changeset: changeset)
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
end
