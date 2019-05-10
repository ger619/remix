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

    resources "/profiles", ProfileController, except: [:delete]
    resources "/users", UserController, except: [:delete]
    get "/dashboard", PageController, :dashboard
    resources "/sessions", SessionController, only: [:delete]
  end
end
