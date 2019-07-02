defmodule Remit.SessionsTest do
  use Remit.DataCase

  alias Remit.Accounts
  alias Remit.Session
  alias Remit.Sessions.Sessionhandler

  setup do
    attrs = %{
      name: "dave",
      phone_number: "8079456",
      email: "dav@gmail.com",
      id_number: "4535453",
      id_type: "national_id",
      super_admin: "false",
      password_hash: "reallyHard2gue$$"
    }

    {:ok, user} = Accounts.create_user(attrs)
    {:ok, user: user}
  end

  def fixture(:session, attrs) do
    {:ok, session} = Sessionhandler.create_session(attrs)
    session
  end

  describe "read session data" do
    test "list_sessions/1 returns all of a user's sessions", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert Sessionhandler.list_session(user) == [session]
    end

    test "get returns the session with given id", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert Sessionhandler.get_session(session.id) == session
    end

    test "change_session/1 returns a session changeset", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert %Ecto.Changeset{} = Sessionhandler.change_session(session)
    end
  end

  describe "write session data" do
    test "create_session/1 with valid data creates a session", %{user: user} do
      create_attrs = %{user_id: user.id}
      assert {:ok, %Session{} = session} = Sessionhandler.create_session(create_attrs)
      assert session.user_id == user.id
      assert DateTime.diff(session.expires_at, DateTime.utc_now()) == 86400
    end

    test "create_session/1 with invalid data returns error changeset" do
      invalid_attrs = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Sessionhandler.create_session(invalid_attrs)
    end

    test "create_session/1 with custom max_age / expiry time", %{user: user} do
      create_attrs = %{user_id: user.id, max_age: 7200}
      assert {:ok, %Session{} = session} = Sessionhandler.create_session(create_attrs)
      assert session.user_id == user.id
      assert DateTime.diff(session.expires_at, DateTime.utc_now()) == 7200
    end
  end

  describe "delete session data" do
    test "delete_session/1 deletes the session", %{user: user} do
      session = fixture(:session, %{user_id: user.id})
      assert {:ok, %Session{}} = Sessionhandler.delete_session(session)
      refute Sessionhandler.get_session(session.id)
    end

    test "delete_user_sessions/1 deletes all of a user's sessions", %{user: user} do
      fixture(:session, %{user_id: user.id})
      assert {1, _} = Sessionhandler.delete_user_sessions(user)
      IO.inspect(user)

      expected = Sessionhandler.list_session(user)
      # assert Sessionhandler.list_sessions(user) == []
    end
  end
end
