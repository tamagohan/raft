defmodule Raft.NodeClusterTest do
  use ExUnit.Case

  test "should start node processes of specified count" do
    {:ok, _} = Raft.NodeCluster.start_link(5)
    %{active: 5, specs: 1, supervisors: 0, workers: 5} = Supervisor.count_children(:sys.get_state(Raft.NodeCluster))
  end
end

