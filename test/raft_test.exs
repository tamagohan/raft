defmodule RaftTest do
  use ExUnit.Case
  doctest Raft

  test "should be follower as initial state and become candidate" do
    {:ok, sup} = Raft.start_peer(:peer1)
    {_, {:local, :peer1_sup}, :one_for_one, _, _, _, _, _, Raft.PeerSup, :peer1} = :sys.get_state(sup)
    config = Raft.State.Config.new!(peer_names: Raft.State.Config.default_peers)
    assert :sys.get_state(:peer1) == {:follower,  %Raft.State{peer_name: :peer1, term: 1, voted_for: nil, config: config}}

    :timer.sleep(1_000)
    assert :sys.get_state(:peer1) == {:candidate, %Raft.State{peer_name: :peer1, term: 2, voted_for: nil, config: config}}

    Supervisor.terminate_child(Raft.Supervisor, sup)
  end
end
