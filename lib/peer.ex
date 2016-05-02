use Croma

defmodule Raft.Peer do

  def start_link(peer_name) do
    IO.puts "[Peer] #{peer_name} starting"
    :gen_fsm.start_link({:local, peer_name}, __MODULE__, peer_name, [])
  end

  defun init(peer_name :: v[Raft.State.PeerName.t]) :: {:ok, :follower, Raft.State.t} do
    config = Raft.State.Config.new!(peer_names: Raft.State.Config.default_peers)
    state  = Raft.State.new!(term: 1, voted_for: nil, peer_name: peer_name, config: config)
    {:ok, :follower, state}
  end
end
