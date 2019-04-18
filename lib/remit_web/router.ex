defmodule RemitWeb.Router do
  use RemitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RemitWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/profiles", ProfileController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RemitWeb do
  #   pipe_through :api
  # end
end
