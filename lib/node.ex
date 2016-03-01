defmodule Raft.Node do
  use GenServer

  def start_link(node_name, node_names) do
    IO.puts "[Node] Starting #{node_name}"
    GenServer.start_link(__MODULE__, {node_name, node_names}, [])
  end

  def init({node_name, node_names}) do
    {:ok,  %{status: :follower, name: node_name, other_node_names: node_names}}
  end
end
