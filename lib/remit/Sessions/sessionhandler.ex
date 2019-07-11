defmodule Remit.Sessions.Sessionhandler do
  @moduledoc """
  The Session context.
  """

  import Ecto.Query, warn: false

  alias Remit.{Repo, User, Session}

  def list_sessions({%User{} = user}) do
    sessions = Repo.preload(user, :sessions).sessions
    Enum.filter(sessions, &(&1.expires_at > DateTime.utc_now()))
  end

  def get_session(id) do
    now = DateTime.utc_now()
    Repo.get(from(s in Session, where: s.expires_at > ^now), id)
  end

  def create_session(attrs \\ %{}) do
    %Session{} |> Session.changeset(attrs) |> Repo.insert()
  end

  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  def delete_user_sessions(%User{} = user) do
    Repo.delete_all(from(s in Session, where: s.user_id == ^user.id))
  end

  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end
end
