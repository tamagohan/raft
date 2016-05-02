defmodule RaftTest do
  use ExUnit.Case
  doctest Raft

  test "should start node processes of specified count" do
    {:ok, sup} = Raft.start_peer(:peer1)
    {_, {:local, :peer1_sup}, :one_for_one, _, _, _, _, _, Raft.PeerSup, :peer1} = :sys.get_state(sup)
    config = Raft.State.Config.new!(peer_names: Raft.State.Config.default_peers)
    assert :sys.get_state(:peer1) == {:follower, %Raft.State{peer_name: :peer1, term: 1, voted_for: nil, config: config}}
  end
end
