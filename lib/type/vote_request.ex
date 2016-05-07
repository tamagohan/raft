use Croma

defmodule Raft.VoteResponse do
  use Croma.Struct, fields: [
    request:  Raft.VoteRequest,
    accepted: Croma.Atom,
  ]
end

defmodule Raft.VoteRequest do
  alias Raft.Member.State

  use Croma.Struct, fields: [
    term: State.Term,
    from: Raft.Peer,
  ]

  defun accept(request :: v[Raft.VoteRequest.t]) :: pid do
    reply(Raft.VoteResponse.new!(request: request, accepted: true))
  end

  defun refuse(request :: v[Raft.VoteRequest.t]) :: pid do
    reply(Raft.VoteResponse.new!(request: request, accepted: false))
  end

  defunp reply(%Raft.VoteResponse{request: %Raft.VoteRequest{from: peer}} = response) :: pid do
    Raft.Peer.send_all_state_event(peer, response)
  end
end
