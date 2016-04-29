use Croma

defmodule Raft.State do
  import Croma.TypeGen
  defmodule Term do
    use Croma.SubtypeOfInt, min: 1, default: 1
  end
  defmodule PeerName do
    @type t :: atom
    def validate(t) when is_atom(t), do: {:ok, t}
    def validate(_),                 do: {:error, {:invalid_value, [__MODULE__]}}
  end
  defmodule PeerNameList do
    use Croma.SubtypeOfList, elem_module: PeerName
  end

  use Croma.Struct, fields: [
    term:       Term,
    voted_for:  nilable(PeerName),
    peer_names: PeerNameList,
  ]
end
