defmodule Raft.Candidate do

  def handle_vote_request(state, request) do
    IO.inspect "receive #{inspect request}"
    # TODO handle vote request event
    {:next_state, :candidate, state}
  end
end
