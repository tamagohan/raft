use Croma

defmodule Raft.VoteRequest do
  use Croma.Struct, fields: [
    term: Term,
    from: Peer,
  ]
end
