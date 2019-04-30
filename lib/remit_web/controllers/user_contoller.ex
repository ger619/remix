defmodule RemitWeb.UserController do
  use RemitWeb, :controller

  alias Remit.Repo
  alias Remit.User

  def index(conn, params) do
    page = case params["query"] do
        nil ->
          User
        term ->
          User.search_query(term)
      end
      |> Repo.paginate(params)

    render(conn, "index.html", users: page.entries, page: page)
  end

  @spec new(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => user_params}) do
    case User.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = User.get_user!(id)
    changeset = User.changeset(user)
    render(conn, "index.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = User.get_user!(id)

    case User.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)


    end
  end


end
