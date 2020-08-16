defmodule CS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CSWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CS.PubSub},
      # Start the Endpoint (http/https)
      CSWeb.Endpoint,
      # Start a worker by calling: CS.Worker.start_link(arg)
      # {CS.Worker, arg}
      {Mongo, Application.get_env(:complains_server, :db)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CS.Supervisor]
    result = Supervisor.start_link(children, opts)

    CS.Startup.ensure_indexes()

    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
