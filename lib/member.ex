use Croma

defmodule Raft.Member do
  alias Raft.Member.State

  def start_link(%Raft.Peer{name: peer_name} = peer) do
    IO.puts "[Member] #{inspect peer} starting"
    :gen_fsm.start_link({:local, peer_name}, __MODULE__, peer, [])
  end

  defun init(peer :: v[Raft.Peer.t]) :: {:ok, :follower, State.t} do
    config = Raft.Config.new!(peers: Raft.Config.load_peers_from_config_file)
    state  = State.new!(term: 1, voted_for: nil, peer: peer, config: config)
    :gen_fsm.send_event_after(Raft.Election.timeout, :timeout)
    {:ok, :follower, state}
  end

  def follower(:timeout, state) do
    Raft.Follower.handle_timeout(state)
  end

  def handle_event(%Raft.VoteRequest{} = request, :candidate, state) do
    Raft.Candidate.handle_vote_request(state, request)
  end
end
