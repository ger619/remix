defmodule RemitWeb.UserController do
  use RemitWeb, :controller

  alias Remit.Repo
  alias Remit.User


  def index(conn, params) do
      #Handles the search

    page = case params["query"]  do
        nil ->
          User
       term ->
         User.search_query(term)

    end|> Repo.paginate(params)


    render(conn, "index.html", users: page.entries, page: page)
  end




  def show(conn, %{"id" => id} )do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
      changeset = User.changeset(%User{})
      render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
      case User.create(user_params) do
        {:ok, user} ->
          conn
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end

    def edit(conn, %{"id" => id}) do
      user = Repo.get!(User, id)
      changeset = User.changeset(%User{}, %{})
      render(conn, "edit.html", changeset: changeset, user: user)
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
      user = Repo.get!(User, id)

      case User.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user, changeset: changeset)
      end
    end
  end
