use Croma

defmodule Raft.PeerSup do
  use Supervisor

  def start_link(peer_name) do
    IO.puts "[PeerSup] #{peer_name} Starting"
    Supervisor.start_link(__MODULE__, peer_name, name: name(peer_name))
  end

  def init(peer_name) do
    children = [worker(Raft.Peer, [peer_name], restart: :transient)]
    supervise(children, strategy: :one_for_one)
  end

  defunp name(peer_name :: v[Raft.Peer.Name.t]) :: atom do
    "#{peer_name}_sup" |> String.to_atom
  end
end
