defmodule Raft.Node do
  use GenServer

  def start_link do
    IO.puts "[Node] Starting"
    GenServer.start_link(__MODULE__, :ok, [])
  end
end
