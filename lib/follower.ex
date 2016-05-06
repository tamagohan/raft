use Croma

defmodule Raft.Follower do
  alias Raft.Member.State

  def handle_timeout(state) do
    if State.voted?(state) do
      :gen_fsm.send_event_after(Raft.Election.timeout, :timeout)
      {:next_state, :follower, state}
    else
      new_state = become_candidate(state)
      {:next_state, :candidate, new_state}
    end
  end

  defunp become_candidate(%State{term: term, peer: peer} = state) :: State.t do
    IO.puts "[Follower] #{inspect peer} became candidate"
    new_state = %State{state | term: term + 1}
    request_voting(new_state)
    new_state
  end

  defunp request_voting(%State{term: term, peer: peer, config: %Raft.Config{peers: peers}}) :: State.t do
    request = %Raft.VoteRequest{term: term, from: peer}
    Raft.Peer.send_all_state_event_to_all_peers(peers, request)
  end
end
