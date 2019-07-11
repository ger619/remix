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
    # plug :guest_pass
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

  # scope "/", RemitWeb do
  #   pipe_through [:browser, :authenticated]
  #   post "/password_change", PasswordController, :create
  #   get "/password_change", PasswordController, :index
  # end

  scope "/", RemitWeb do
    pipe_through [:browser, :authenticated]

    get "/dashboard", PageController, :dashboard
    resources "/profiles", ProfileController, except: [:delete]

    get "/password_change", PasswordController, :index
    post "/password_change", PasswordController, :create

    resources "/users", UserController
    post "/user/:id/reset", UserController, :reset_action

    resources "/sessions", SessionController, only: [:delete]
  end
end
