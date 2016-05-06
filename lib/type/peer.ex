use Croma

defmodule Raft.Peer do
  defmodule NodeName do
    @type t :: atom
    def validate(t) when is_atom(t), do: {:ok, t}
    def validate(_),                 do: {:error, {:invalid_value, [__MODULE__]}}
  end

  defmodule Name do
    @type t :: atom
    def validate(t) when is_atom(t), do: {:ok, t}
    def validate(_),                 do: {:error, {:invalid_value, [__MODULE__]}}
  end

  use Croma.Struct, fields: [
    node_name: NodeName,
    name:      Name,
  ]

  defun send_all_state_event_to_all_peers(peers :: v[Raft.Config.PeerList.t], event :: any) :: :ok do
    Enum.each(peers, fn peer -> send_all_state_event(peer, event) end)
  end

  defunp send_all_state_event(%Raft.Peer{node_name: node_name, name: peer_name}, event :: any) :: pid do
    Node.spawn(node_name, fn -> :gen_fsm.send_all_state_event(peer_name, event) end)
  end
end
