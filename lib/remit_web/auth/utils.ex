defmodule RemitWeb.Auth.Utils do
  @moduledoc """
  Helper functions for authentication.
  """

  alias Remit.Sessions.Sessionhandler

  def create_session(%Plug.Conn{assigns: %{current_user: %{id: user_id}}}) do
    Sessionhandler.create_session(%{user_id: user_id})
  end
end
