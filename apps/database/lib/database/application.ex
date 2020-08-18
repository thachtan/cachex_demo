defmodule Database.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @node_cache_list [ :a@Tan, :b@Tan, :c@Tan ]

  use Application
  require Logger

  def start(_type, _args) do

    Cachex.start_link(:item_cache, nodes: @node_cache_list)

    children = [
      # Start the Ecto repository
      Database.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Database.PubSub}
      # Start a worker by calling: Database.Worker.start_link(arg)
      # {Database.Worker, arg}

    ]




    Supervisor.start_link(children, strategy: :one_for_one, name: Database.Supervisor)
  end
end
