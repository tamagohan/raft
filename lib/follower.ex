use Croma

defmodule Raft.Follower do
  alias Raft.Member.State

  defun handle_timeout(state :: v[State.t]) :: Raft.Member.result do
    if State.voted?(state) do
      :gen_fsm.send_event_after(Raft.Election.timeout, :timeout)
      {:next_state, :follower, state}
    else
      :gen_fsm.send_event_after(0, :timeout)
      new_state = become_candidate(state)
      {:next_state, :candidate, new_state}
    end
  end

  defun handle_vote_request(%State{voted_for: voted_for} = state, request :: v[Raft.VoteRequest.t]) :: Raft.Member.result do
    IO.puts "[Follower] receive #{inspect request}"
    # TODO should check term and log index
    if is_nil(voted_for) do
      Raft.VoteRequest.accept(request)
    else
      Raft.VoteRequest.refuse(request)
    end
    {:next_state, :candidate, state}
  end

  defunp become_candidate(%State{term: term, peer: peer} = state) :: State.t do
    IO.puts "[Follower] #{inspect peer} became candidate"
    new_state = %State{state | term: term + 1}
    new_state
  end
end
