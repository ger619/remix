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

    get "/dashboard", PageController, :dashboard

    get "/password-change", PasswordController, :index
    post "/password-change", PasswordController, :create

    resources "/profiles", ProfileController, except: [:delete]
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:delete]

    get "/new-profile", ProfileController, :new_business_profile
    post "/new-pofile", ProfileController, :create_business_profile
  end
end
