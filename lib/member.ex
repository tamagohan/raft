use Croma

defmodule Raft.Member do
  alias Raft.Member.State

  @typep label_t :: :follower | :candidate | :leader
  @type  result  :: {any, label_t, State.t}

  def start_link(%Raft.Peer{name: peer_name} = peer) do
    IO.puts "[Member] #{inspect peer} starting"
    :gen_fsm.start_link({:local, peer_name}, __MODULE__, peer, [])
  end

  defun init(peer :: v[Raft.Peer.t]) :: result do
    config = Raft.Config.new!(peers: Raft.Config.load_peers_from_config_file)
    state  = State.new!(term: 1, voted_for: nil, peer: peer, config: config)
    :gen_fsm.send_event_after(Raft.Election.timeout, :timeout)
    {:ok, :follower, state}
  end

  defun follower(:timeout, state :: v[State.t]) :: result do
    Raft.Follower.handle_timeout(state)
  end

  defun candidate(:timeout, state :: v[State.t]) :: result do
    Raft.Candidate.handle_timeout(state)
  end

  defun handle_event(%Raft.VoteRequest{} = request, label :: label_t, state :: v[State.t]) :: result do
    apply(label_module(label), :handle_vote_request, [state, request])
  end

  defun handle_event(%Raft.VoteResponse{} = response, label :: label_t, state :: v[State.t]) :: result do
    apply(label_module(label), :handle_vote_response, [state, response])
  end

  defunp label_module(label :: label_t) :: module do
    case label do
      :follower  -> Raft.Follower
      :candidate -> Raft.Candidate
      :leader    -> Raft.Leader
    end
  end
end
