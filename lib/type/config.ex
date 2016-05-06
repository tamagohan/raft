use Croma

defmodule Raft.Config do
  defmodule PeerList do
    use Croma.SubtypeOfList, elem_module: Raft.Peer, min_length: 1
  end

  use Croma.Struct, fields: [
    peers: PeerList
  ]

  defun load_peers_from_config_file :: PeerList.t do
    # TODO load from config file
    Enum.map([:peer1, :peer2, :peer3], fn peer_name ->
      Raft.Peer.new!(node_name: :"#{peer_name}@127.0.0.1", name: peer_name)
    end)
  end
end
