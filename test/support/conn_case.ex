defmodule RemitWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  import Phoenix.ConnTest

  alias Remit.Repo
  alias Remit.User

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias RemitWeb.Router.Helpers, as: Routes

      import RemitWeb.TestUtil

      # The default endpoint for testing
      @endpoint RemitWeb.Endpoint
    end
  end

  # Define default endpoint for testing
  @endpoint RemitWeb.Endpoint

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Remit.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Remit.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    conn =
      if params = tags[:authenticate] do
        conn
        |> authenticate(params)
      else
        conn
      end

    {:ok, conn: conn}
  end

  defp authenticate(conn, params) do
    params =
      Map.merge(
        %{
          name: "An Admin",
          phone_number: "0700000000",
          email: "user@example.com",
          id_number: "0000001",
          id_type: "national_id",
          password_hash: Bcrypt.hash_pwd_salt("admin123")
        },
        params
      )

    user =
      Ecto.Changeset.change(%User{}, params)
      |> Repo.insert!()

    conn
    |> bypass_through(RemitWeb.Router, [:browser])
    |> get("/")
    |> RemitWeb.SessionController.add_session(user, %{})
    |> Plug.Conn.send_resp(200, "Flush the session yo!")
    |> recycle()
  end
end
