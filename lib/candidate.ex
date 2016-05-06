use Croma

defmodule Raft.Candidate do
  alias Raft.Member.State

  def handle_timeout(state) do
    request_voting(state)
    {:next_state, :candidate, state}
  end

  def handle_vote_request(state, request) do
    IO.inspect "[Candidate] receive #{inspect request}"
    # TODO handle vote request event
    {:next_state, :candidate, state}
  end

  defunp request_voting(%State{term: term, peer: peer, config: %Raft.Config{peers: peers}}) :: State.t do
    request = %Raft.VoteRequest{term: term, from: peer}
    Raft.Peer.send_all_state_event_to_all_peers(peers, request)
  end
end
