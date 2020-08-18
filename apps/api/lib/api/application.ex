defmodule Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(type, _args) do
    import Supervisor.Spec
    children = [
      # Starts a worker by calling: Api.Worker.start_link(arg)
      # {Api.Worker, arg}
      worker(ItemApi, [])
    ]

    case type do
      :normal ->
        Logger.info("Application API is started on #{node()}")

      {:takeover, old_node} ->
        Logger.info("#{node()} is taking over #{old_node}")

      {:failover, old_node} ->
        Logger.info("#{old_node} is failing over to #{node()}")
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
