use Croma

defmodule Raft.State do
  import Croma.TypeGen

  defmodule PeerName do
    use Croma.SubtypeOfAtom, values: [:peer1, :peer2, :peer3]
  end

  defmodule PeerNameList do
    use Croma.SubtypeOfList, elem_module: PeerName, min_length: 1
  end

  defmodule Config do
    use Croma.Struct, fields: [
      peer_names: PeerNameList
    ]

    defun default_peers :: PeerNameList.t do
      [:peer1, :peer2, :peer3]
    end
  end

  defmodule Term do
    use Croma.SubtypeOfInt, min: 1, default: 1
  end

  use Croma.Struct, fields: [
    term:       Term,
    voted_for:  nilable(PeerName),
    peer_name:  PeerName,
    config:     Config,
  ]

  defun voted?(%Raft.State{voted_for: voted_for}) :: boolean do
    !is_nil(voted_for)
  end
end
