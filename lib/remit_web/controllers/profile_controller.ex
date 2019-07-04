defmodule RemitWeb.ProfileController do
  use RemitWeb, :controller

  alias Remit.{Profile, Repo}

  def index(conn, params) do
    page =
      case params["query"] do
        nil ->
          Profile

        term ->
          Profile.search_query(term)
      end
      |> Repo.paginate(params)

    render(conn, "index.html", profile: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = Profile.changeset(%Profile{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"profile" => profile_params}) do
    case Profile.create(profile_params, "business") do
      {:ok, profile} ->
        conn
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    changeset = Profile.edit_profile(profile)
    render(conn, "edit.html", changeset: changeset, profile: profile)
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Profile.get_profile!(id)

    case Profile.update_profile(profile, profile_params) do
      {:ok, profile} ->
        conn
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profile: profile, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    render(conn, "show.html", profile: profile)
  end

  def delete(conn, %{"id" => id}) do
    profile =
      Repo.get!(Profile, id)
      |> Profile.delete_profile()

    conn
    |> put_flash(:info, "Profile deleted successfully")
    |> redirect(to: Routes.profile_path(conn, :show, profile))
  end

  def new_business_profile(conn, _params) do
    changeset = Profile.changeset(%Profile{})
    render(conn, "new_business_profile.html", changeset: changeset)
  end

  def create_business_profile(conn, %{"profile" => profile_params}) do
    case Profile.create_with_user(conn.assigns.current_user, profile_params) do
      {:ok, _profile} ->
        conn
        |> redirect(to: Routes.page_path(conn, :dashboard))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new_business_profile.html", changeset: changeset)
    end
  end
end
