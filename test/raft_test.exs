defmodule RaftTest do
  use ExUnit.Case
  doctest Raft

  test "should start node processes of specified count" do
    {:ok, sup} = Raft.start_peer(:test_peer)
    {_, {:local, :test_peer_sup}, :one_for_one, _, _, _, _, _, Raft.PeerSup, :test_peer} = :sys.get_state(sup)
  end
end
