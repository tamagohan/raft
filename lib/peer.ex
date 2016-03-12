defmodule Raft.Peer do
  use GenServer

  def start_link(peer_name) do
    IO.puts "[Peer] #{peer_name} starting"
    GenServer.start_link(__MODULE__, [peer_name], [name: peer_name])
  end

  def init(peer_name) do
    {:ok,  %{status: :follower, name: peer_name}}
  end
end
