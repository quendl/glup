defmodule Glup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Glup.Repo,
      # Start the Telemetry supervisor
      GlupWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Glup.PubSub},
      # Start the Endpoint (http/https)
      GlupWeb.Endpoint,
      # Events Supervisor
      {GlupWeb.Events.Supervisor, [nil]}
      # Start a worker by calling: Glup.Worker.start_link(arg)
      # {Glup.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Glup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GlupWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
