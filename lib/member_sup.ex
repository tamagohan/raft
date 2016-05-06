use Croma

defmodule Raft.MemberSup do
  use Supervisor

  def start_link(%Raft.Peer{name: peer_name} = peer) do
    IO.puts "[MemberSup] #{inspect peer} Starting"
    Supervisor.start_link(__MODULE__, peer, name: name(peer_name))
  end

  def init(peer) do
    children = [worker(Raft.Member, [peer], restart: :transient)]
    supervise(children, strategy: :one_for_one)
  end

  defunp name(peer_name :: v[Raft.Peer.Name.t]) :: atom do
    "#{peer_name}_sup" |> String.to_atom
  end
end
