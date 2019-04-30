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
    changeset = User.change_user()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case User.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   user = User.get_user!(id)
  #   render(conn, "show.html", user: user)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   user = User.get_user!(id)
  #   changeset = User.change_user(user)
  #   render(conn, "edit.html", user: user, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = User.get_user!(id)
  #
  #   case User.update_user(user, user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User updated successfully.")
  #       |> redirect(to: Routes.user_path(conn, :show, user))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", user: user, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   user = User.get_user!(id)
  #   {:ok, _user} = User.delete_user(user)
  #
  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: Routes.user_path(conn, :index))
  # end
end