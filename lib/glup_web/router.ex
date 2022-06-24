defmodule GlupWeb.Router do
  use GlupWeb, :router

  pipeline :api do
    plug GlupWeb.Plugs.RateLimiter
    plug :accepts, ["json"]
    plug GlupWeb.Plugs.AuthPlug
  end

  scope "/", GlupWeb do
    pipe_through :api

    post "/login", UserController, :login
    post "/signup", UserController, :signup
    get "/test", UserController, :test

  end
end
