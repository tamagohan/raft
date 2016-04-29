defmodule Raft.Peer do

  def start_link(peer_name) do
    IO.puts "[Peer] #{peer_name} starting"
    :gen_fsm.start_link({:local, peer_name}, __MODULE__, [peer_name], [])
  end

  def init(peer_names) do
    state = Raft.State.new!(term: 1, voted_for: nil, peer_names: peer_names)
    {:ok, :follower, state}
  end
end
