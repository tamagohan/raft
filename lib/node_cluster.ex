defmodule Raft.NodeCluster do
  use GenServer
  import Supervisor.Spec

  def start_link(number_of_nodes) do
    IO.puts "[NodeCluster] Starting (number of nodes is #{number_of_nodes})"
    GenServer.start_link(__MODULE__, number_of_nodes, name: __MODULE__)
  end

  def init(number_of_nodes) do
    children = [worker(Raft.Node, [], restart: :temporary)]
    opts     = [strategy: :simple_one_for_one]
    {:ok, sup} = Supervisor.start_link(children, opts)

    send(self, {:start_node_processes, number_of_nodes})
    {:ok, sup}
  end

  def handle_info({:start_node_processes, number_of_nodes}, sup) do
    node_names = generate_node_names(number_of_nodes)
    Enum.each(node_names, fn node_name ->
      node_names_without_self = List.delete(node_names, node_name)
      {:ok, _pid} = Supervisor.start_child(sup, [node_name, node_names_without_self])
    end)
    {:noreply, sup}
  end

  defp generate_node_names(number_of_nodes) when is_integer(number_of_nodes) do
    for i <- 1..number_of_nodes do "node#{i}" |> String.to_atom end
  end
end
