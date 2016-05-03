use Croma

defmodule Raft.Peer do

  alias Raft.State

  @min_election_timeout   500
  @max_election_timeout 1_000

  def start_link(peer_name) do
    IO.puts "[Peer] #{peer_name} starting"
    :gen_fsm.start_link({:local, peer_name}, __MODULE__, peer_name, [])
  end

  defun init(peer_name :: v[State.PeerName.t]) :: {:ok, :follower, State.t} do
    config = State.Config.new!(peer_names: State.Config.default_peers)
    state  = State.new!(term: 1, voted_for: nil, peer_name: peer_name, config: config)
    :gen_fsm.send_event_after(election_timeout, :timeout)
    {:ok, :follower, state}
  end

  def follower(:timeout, state) do
    if State.voted?(state) do
      :gen_fsm.send_event_after(election_timeout, :timeout)
      {:next_state, :follower, state}
    else
      new_state = become_candidate(state)
      {:next_state, :candidate, new_state}
    end
  end

  defunp election_timeout :: pos_integer do
    Enum.random(@min_election_timeout..@max_election_timeout)
  end

  defunp become_candidate(%State{term: term, peer_name: peer_name} = state) :: State.t do
    IO.puts "[Peer] #{peer_name} became candidate"
    %State{state | term: term + 1}
  end
end
