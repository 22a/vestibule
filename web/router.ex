defmodule Vestibule.Router do
  use Vestibule.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Vestibule do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", Vestibule do
    pipe_through :protected

    resources "/teams", TeamController
    resources "/contests", ContestController
    resources "/problems", ProblemController do
      get "/attempt", AttemptController, :new
    end
    resources "/attempts", AttemptController
    resources "/results", ResultController
    resources "/scores", ScoreController
  end

  if Mix.env == :dev do
    scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/dev/mailbox"]
    end
  end
end
