use Croma

defmodule Raft.StateTest do
  use ExUnit.Case

  alias Raft.State, as: S

  test "RaftState.Config: new/1" do
    assert S.Config.new(peer_names: [:peer1]) == {:ok, %S.Config{peer_names: [:peer1]}}

    assert S.Config.new(peer_names: [])              == {:error, {:invalid_value, [S.Config, S.PeerNameList]}}
    assert S.Config.new(peer_names: [:invalid_name]) == {:error, {:invalid_value, [S.Config, S.PeerNameList, S.PeerName]}}
    assert S.Config.new(peer_names: "not list")      == {:error, {:invalid_value, [S.Config, S.PeerNameList]}}
  end

  test "RaftState: new/1" do
    config = S.Config.new!(peer_names: S.Config.default_peers)
    assert S.new(term: 1, voted_for: nil, peer_name: :peer1, config: config) == {:ok, %S{term: 1, voted_for: nil, peer_name: :peer1, config: config}}
    assert S.new(         voted_for: nil, peer_name: :peer1, config: config) == {:ok, %S{term: 1, voted_for: nil, peer_name: :peer1, config: config}}

    assert S.new(voted_for: nil)                    == {:error, {:value_missing, [S, S.PeerName]}}
    assert S.new(voted_for: nil, peer_name: :peer1) == {:error, {:value_missing, [S, S.Config]}}
    assert S.new(term: "not integer", voted_for: nil, peer_name: :peer1,        config: config)           == {:error, {:invalid_value, [S, S.Term]}}
    assert S.new(term: 1,             voted_for: nil, peer_name: :invalid_name, config: config)           == {:error, {:invalid_value, [S, S.PeerName]}}
    assert S.new(term: 1,             voted_for: nil, peer_name: :peer1,        config: "invalid config") == {:error, {:invalid_value, [S, S.Config]}}
  end
end
