defmodule Remit.SessionsTest do
  use Remit.DataCase

  alias Remit.{Accounts, Session, Sessions.Sessionhandler}

  setup do
    attrs = %{phone_number: "123456", password: "reallyHard2gue$$"}
    {:ok, user} = Accounts.create_user(attrs)
    {:ok, user: user}
  end

  def fixture(:session, attrs) do
    {:ok, session} = Session.create_session(attrs)
    session
  end

  describe "read session data" do
    test "list_sessions/1 returns all of a user's sessions", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert Session.list_sessions(user) == [session]
    end

    test "get returns the session with given id", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert Session.get_session(session.id) == session
    end

    test "change_session/1 returns a session changeset", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert %Ecto.Changeset{} = Sessions.change_session(session)
    end
  end

  describe "write session data" do
    test "create_session/1 with valid data creates a session", %{user: user} do
      create_attrs = %{user_id: user.id}
      assert {:ok, %Sessionhandler{} = session} = Session.create_session(create_attrs)
      assert session.user_id == user.id
      assert DateTime.diff(session.expires_at, DateTime.utc_now()) == 86400
    end

    test "create_session/1 with invalid data returns error changeset" do
      invalid_attrs = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Session.create_session(invalid_attrs)
    end

    test "create_session/1 with custom max_age / expiry time", %{user: user} do
      create_attrs = %{user_id: user.id, max_age: 7200}
      assert {:ok, %Sessionhandler{} = session} = Session.create_session(create_attrs)
      assert session.user_id == user.id
      assert DateTime.diff(session.expires_at, DateTime.utc_now()) == 7200
    end
  end

  describe "delete session data" do
    test "delete_session/1 deletes the session", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert {:ok, %Sessionhandler{}} = Session.delete_session(session)
      refute Session.get_session(session.id)
    end

    test "delete_user_sessions/1 deletes all of a user's sessions", %{user: user} do
      fixture(:session, %{user_id: user.id})
      fixture(:session, %{user_id: user.id})
      assert {2, _} = Session.delete_user_sessions(user)
      assert Session.list_sessions(user) == []
    end
  end
end
