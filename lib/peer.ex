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

  def handle_event(%Raft.VoteRequest{}, :candidate, state) do
    IO.inspect "receive vote request event"
    # TODO handle vote request event
    {:next_state, :candidate, state}
  end

  defunp election_timeout :: pos_integer do
    Enum.random(@min_election_timeout..@max_election_timeout)
  end

  defunp become_candidate(%State{term: term, peer_name: peer_name} = state) :: State.t do
    IO.puts "[Peer] #{peer_name} became candidate"
    new_state = %State{state | term: term + 1}
    request_voting(new_state)
    new_state
  end

  defunp request_voting(%State{term: term, peer_name: peer_name} = state) :: State.t do
    request = %Raft.VoteRequest{term: term, from: peer_name}
    send_to_all_peers(state, request)
  end

  defp send_to_all_peers(%State{config: %State.Config{peer_names: peer_names}}, event) do
    Enum.each(peer_names, fn peer_name ->
      try do
        :gen_fsm.send_all_state_event(peer_name, event)
      rescue
        ArgumentError -> IO.inspect "could not send #{inspect(event)} to #{peer_name}"
      end
    end)
  end
end
