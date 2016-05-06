use Croma

defmodule Raft.Follower do
  alias Raft.Member.State

  def handle_timeout(state) do
    if State.voted?(state) do
      :gen_fsm.send_event_after(Raft.Election.timeout, :timeout)
      {:next_state, :follower, state}
    else
      :gen_fsm.send_event_after(0, :timeout)
      new_state = become_candidate(state)
      {:next_state, :candidate, new_state}
    end
  end

  defunp become_candidate(%State{term: term, peer: peer} = state) :: State.t do
    IO.puts "[Follower] #{inspect peer} became candidate"
    new_state = %State{state | term: term + 1}
    new_state
  end
end
