use Croma

defmodule Raft.State do
  import Croma.TypeGen

  defmodule Term do
    use Croma.SubtypeOfInt, min: 1, default: 1
  end

  use Croma.Struct, fields: [
    term:       Term,
    voted_for:  nilable(Peer),
    peer:       Raft.Peer,
    config:     Raft.Config,
  ]

  defun voted?(%Raft.State{voted_for: voted_for}) :: boolean do
    !is_nil(voted_for)
  end
end
