defmodule RemitWeb.Router do
  use RemitWeb, :router
  import RemitWeb.Authorize

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phauxth.Authenticate
    plug Phauxth.Remember, create_session_func: &RemitWeb.Auth.Utils.create_session/1
  end

  pipeline :authenticated do
    plug :user_check
  end

  pipeline :requires_password_change do
    plug :check_requires_password_change
  end

  pipeline :guest do
    plug :guest_check
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RemitWeb do
    pipe_through [:browser, :guest_check]

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create]
  end

  scope "/", RemitWeb do
    pipe_through [:browser, :authenticated]

    post "/password_change", PasswordController, :create
    get "/password_change", PasswordController, :index
  end

  scope "/", RemitWeb do
    pipe_through [:browser, :authenticated, :requires_password_change]

    get "/dashboard", PageController, :dashboard
    resources "/profiles", ProfileController, except: [:delete]

    resources "/users", UserController
    post "/user/:id/reset", UserController, :reset_action

    resources "/sessions", SessionController, only: [:delete]
  end

  defp check_requires_password_change(conn, _opts) do
    if conn.assigns.current_user.require_password_change do
      conn
      |> redirect(to: RemitWeb.Router.Helpers.password_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
