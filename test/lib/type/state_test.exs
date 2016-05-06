use Croma

defmodule Raft.StateTest do
  use ExUnit.Case

  alias Raft.{Config, Peer}
  alias Raft.Member.State

  test "Raft.Config: new/1" do
    peer = Peer.new!(name: :peer1, node_name: :"peer1@127.0.0.1")
    assert Config.new(peers: [peer]) == {:ok, %Config{peers: [peer]}}

    assert Config.new(peers: [])              == {:error, {:invalid_value, [Config, Config.PeerList]}}
    assert Config.new(peers: [:invalid_peer]) == {:error, {:invalid_value, [Config, Config.PeerList, Peer]}}
    assert Config.new(peers: "not list")      == {:error, {:invalid_value, [Config, Config.PeerList]}}
  end

  test "Raft.State: new/1" do
    peer   = Peer.new!(name: :peer1, node_name: :"peer1@127.0.0.1")
    config = Config.new!(peers: Config.load_peers_from_config_file)
    assert State.new(term: 1, voted_for: nil, peer: peer, config: config) == {:ok, %State{term: 1, voted_for: nil, peer: peer, config: config}}
    assert State.new(         voted_for: nil, peer: peer, config: config) == {:ok, %State{term: 1, voted_for: nil, peer: peer, config: config}}

    assert State.new(voted_for: nil)             == {:error, {:value_missing, [State, Peer]}}
    assert State.new(voted_for: nil, peer: peer) == {:error, {:value_missing, [State, Config]}}
    assert State.new(term: "not integer", voted_for: nil, peer: peer,          config: config)           == {:error, {:invalid_value, [State, State.Term]}}
    assert State.new(term: 1,             voted_for: nil, peer: :invalid_name, config: config)           == {:error, {:invalid_value, [State, Peer]}}
    assert State.new(term: 1,             voted_for: nil, peer: peer,          config: "invalid config") == {:error, {:invalid_value, [State, Config]}}
  end
end
