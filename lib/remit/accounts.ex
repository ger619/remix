defmodule Remit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Remit.Repo
  alias Remit.User
  alias Remit.Profile
  alias Remit.Session
  alias Remit.Sessions.Sessionhandler

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a user based on the params.

  This is used by Phauxth to get user information.
  """
  def get_by(%{"session_id" => session_id}) do
    with %Session{user_id: user_id} <- Sessionhandler.get_session(session_id),
         do: get_user!(user_id)
  end

  def get_by(%{"phone_number" => phone_number}) do
    Repo.get_by(User, phone_number: phone_number)
  end

  def get_by(%{"user_id" => user_id}), do: Repo.get(User, user_id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_user(user) do
    Repo.transaction(fn ->
      changeset =
        %User{}
        |> Ecto.Changeset.change(require_password_change: true)
        |> User.changeset(user)

      result = Repo.insert(changeset)

      case result do
        {:ok, user} ->
          case Profile.create(%{name: user.name, currency: "KES"}, "user") do
            {:ok, _} ->
              user

            {:error, _} ->
              changeset = changeset |> Ecto.Changeset.add_error(:name, "already exists.")
              Repo.rollback(%{changeset | action: :insert})
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}Repo.get!(Profile, id)

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def delete_user!(user) do
    result =
      from(u in User, select: [:id, :deleted_at], where: u.id == ^user.id and is_nil(u.deleted_at))
      |> Repo.update_all(set: [deleted_at: DateTime.utc_now() |> DateTime.truncate(:second)])

    case result do
      {1, [deleted_user]} ->
        deleted_user

      _ ->
        user
    end
  end
end
