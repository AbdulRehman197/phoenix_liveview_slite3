defmodule PheonixLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PheonixLive.Repo,
      # Start the Telemetry supervisor
      PheonixLiveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PheonixLive.PubSub},
      # Start the Endpoint (http/https)
      PheonixLiveWeb.Endpoint
      # Start a worker by calling: PheonixLive.Worker.start_link(arg)
      # {PheonixLive.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PheonixLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PheonixLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
