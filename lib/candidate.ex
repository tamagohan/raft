use Croma

defmodule Raft.Candidate do
  alias Raft.Member.State

  defun handle_timeout(state :: v[State.t]) :: Raft.Member.result do
    request_voting(state)
    {:next_state, :candidate, state}
  end

  defun handle_vote_request(state :: v[State.t], request :: v[Raft.VoteRequest.t]) :: Raft.Member.result do
    IO.puts "[Candidate] receive #{inspect request}"
    Raft.VoteRequest.refuse(request)
    {:next_state, :candidate, state}
  end


  defun handle_vote_response(%State{peer: peer} = state, response :: v[Raft.VoteResponse.t]) :: Raft.Member.result do
    IO.puts "[Candidate] receive #{inspect response}"
    IO.puts "[Candidate] #{inspect peer} became leader"
    # TODO check if vote count > number of member / 2
    {:next_state, :leader, state}
  end

  defunp request_voting(%State{term: term, peer: peer, config: %Raft.Config{peers: peers}}) :: :ok do
    request = Raft.VoteRequest.new!(term: term, from: peer)
    Raft.Peer.send_all_state_event_to_all_peers(peers, request)
  end
end
