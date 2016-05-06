use Croma

defmodule Raft do
  import Supervisor.Spec

  def start(_, _) do
    children = [supervisor(Raft.PeerSup, [])]
    opts = [strategy: :simple_one_for_one, name: Raft.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defun start_peer(peer_name :: v[Raft.Peer.Name.t]) :: {:ok, pid} do
    Supervisor.start_child(Raft.Supervisor, [peer_name])
  end
end
