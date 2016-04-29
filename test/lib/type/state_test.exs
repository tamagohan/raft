use Croma

defmodule Raft.StateTest do
  use ExUnit.Case

  test "RaftState: new/1" do
    alias Raft.State, as: S
    assert S.new(term: 1, voted_for: nil, peer_names: [:peer]) == {:ok, %S{term: 1, voted_for: nil, peer_names: [:peer]}}
    assert S.new(voted_for: nil, peer_names: [:peer])          == {:ok, %S{term: 1, voted_for: nil, peer_names: [:peer]}}

    assert S.new(voted_for: nil)                                                 == {:error, {:value_missing, [S, S.PeerNameList]}}
    assert S.new(term: "not integer", voted_for: nil, peer_names: [:peer])       == {:error, {:invalid_value, [S, S.Term]}}
    assert S.new(term: 1, voted_for: nil, peer_names: ["not peer_name type"])    == {:error, {:invalid_value, [S, S.PeerNameList, S.PeerName]}}
    assert S.new(term: 1, voted_for: nil, peer_names: "not peer_name type list") == {:error, {:invalid_value, [S, S.PeerNameList]}}
  end
end
