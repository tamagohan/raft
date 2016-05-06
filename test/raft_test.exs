defmodule RaftTest do
  use ExUnit.Case
  doctest Raft

  test "should be follower as initial state and become candidate" do
    {:ok, sup} = Raft.start_peer(:peer1)
    {_, {:local, :peer1_sup}, :one_for_one, _, _, _, _, _, Raft.MemberSup, :peer1} = :sys.get_state(sup)
    config = Raft.Config.new!(peers: Raft.Config.load_peers_from_config_file)
    peer   = Raft.Peer.new!(name: :peer1, node_name: :"peer1@127.0.0.1")
    assert :sys.get_state(:peer1) == {:follower,  %Raft.Member.State{peer: peer, term: 1, voted_for: nil, config: config}}

    :timer.sleep(1_000)
    assert :sys.get_state(:peer1) == {:candidate, %Raft.Member.State{peer: peer, term: 2, voted_for: nil, config: config}}

    Supervisor.terminate_child(Raft.Supervisor, sup)
  end
end
