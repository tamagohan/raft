use Croma

defmodule RaftTest do
  use ExUnit.Case

  @peers_for_test "PEERS_FOR_TEST"

  test "should be follower as initial state and become candidate" do
    peer = Raft.Peer.new!(name: :peer1, node_name: Node.self)
    with_peers_config([peer], fn ->
      {:ok, sup} = Raft.start_peer(:peer1)

      {_, {:local, :peer1_sup}, :one_for_one, _, _, _, _, _, Raft.MemberSup, ^peer} = :sys.get_state(sup)
      config = Raft.Config.new!(peers: Raft.Config.load_peers_from_config_file)
      assert :sys.get_state(:peer1) == {:follower,  %Raft.Member.State{peer: peer, term: 1, voted_for: nil, config: config}}

      :timer.sleep(1_000)
      assert :sys.get_state(:peer1) == {:candidate, %Raft.Member.State{peer: peer, term: 2, voted_for: nil, config: config}}

      Supervisor.terminate_child(Raft.Supervisor, sup)
    end)
  end

  defun with_peers_config(peers :: [Raft.Peer], func :: fun) :: :ok do
    try do
      System.put_env(@peers_for_test, inspect(peers))
      func.()
    after
      System.put_env(@peers_for_test, "")
    end
  end
end
