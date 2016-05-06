use Croma

defmodule Raft.Config do
  @peers_config_file_path "config/peers.exs"

  defmodule PeerList do
    use Croma.SubtypeOfList, elem_module: Raft.Peer, min_length: 1
  end

  use Croma.Struct, fields: [
    peers: PeerList
  ]

  defun load_peers_from_config_file :: PeerList.t do
    if Mix.env == :test do
      peers_str = System.get_env("PEERS_FOR_TEST")
      {peers, _bindings} = Code.eval_string(peers_str)
      peers
    else
      {peers, _bindings} = Code.eval_file(@peers_config_file_path)
      peers
    end
  end
end
