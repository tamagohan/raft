use Croma

defmodule Raft do
  use GenServer
  import Supervisor.Spec

  defun start(number_of_nodes :: g[pos_integer] \\ 5) :: {:ok, pid} do
    children = [
      supervisor(Raft.NodeManager, [number_of_nodes], restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: Raft.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
