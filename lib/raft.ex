defmodule Raft do
  use GenServer
  import Supervisor.Spec

  def start(number_of_nodes \\ 5) when is_integer(number_of_nodes) and number_of_nodes > 0 do
    children = [
      supervisor(Raft.NodeCluster, [number_of_nodes], restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: Raft.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
