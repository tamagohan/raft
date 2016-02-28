defmodule Raft.NodeCluster do
  use GenServer
  import Supervisor.Spec

  def start_link(number_of_nodes) do
    IO.puts "[NodeCluster] Starting (number of nodes is #{number_of_nodes})"
    GenServer.start_link(__MODULE__, number_of_nodes, [])
  end

  def init(number_of_nodes) do
    children = [worker(Raft.Node, [], restart: :temporary)]
    opts = [strategy: :simple_one_for_one, name: Hoge]
    {:ok, sup} = Supervisor.start_link(children, opts)

    for _ <- 1..number_of_nodes do
      {:ok, _pid} = Supervisor.start_child(sup, [])
    end
    {:ok, sup}
  end
end

