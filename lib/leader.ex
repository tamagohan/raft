use Croma

defmodule Raft.Leader do
  alias Raft.Member.State

  defun handle_vote_request(state :: v[State.t], request :: v[Raft.VoteRequest.t]) :: Raft.Member.result do
    IO.puts "[Leader] receive #{inspect request}"
    Raft.VoteRequest.refuse(request)
    {:next_state, :leader, state}
  end


  defun handle_vote_response(state :: v[Sate.t], response :: v[Raft.VoteResponse.t]) :: Raft.Member.result do
    IO.puts "[leader] receive #{inspect response}"
    {:next_state, :leader, state}
  end
end
