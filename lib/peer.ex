use Croma

defmodule Raft.Peer do
  alias Raft.State

  @min_election_timeout   500
  @max_election_timeout 1_000

  defmodule NodeName do
    @type t :: atom
    def validate(t) when is_atom(t), do: {:ok, t}
    def validate(_),                 do: {:error, {:invalid_value, [__MODULE__]}}
  end

  defmodule Name do
    @type t :: atom
    def validate(t) when is_atom(t), do: {:ok, t}
    def validate(_),                 do: {:error, {:invalid_value, [__MODULE__]}}
  end

  use Croma.Struct, fields: [
    node_name: NodeName,
    name:      Name,
  ]

  def start_link(peer_name) do
    IO.puts "[Peer] #{peer_name} starting"
    :gen_fsm.start_link({:local, peer_name}, __MODULE__, peer_name, [])
  end

  defun init(peer_name :: v[Raft.Peer.Name.t]) :: {:ok, :follower, State.t} do
    peer   = Raft.Peer.new!(node_name: :"#{peer_name}@127.0.0.1", name: peer_name)
    config = Raft.Config.new!(peers: Raft.Config.load_peers_from_config_file)
    state  = State.new!(term: 1, voted_for: nil, peer: peer, config: config)
    :gen_fsm.send_event_after(election_timeout, :timeout)
    {:ok, :follower, state}
  end

  def follower(:timeout, state) do
    if State.voted?(state) do
      :gen_fsm.send_event_after(election_timeout, :timeout)
      {:next_state, :follower, state}
    else
      new_state = become_candidate(state)
      {:next_state, :candidate, new_state}
    end
  end

  def handle_event(%Raft.VoteRequest{}, :candidate, state) do
    IO.inspect "receive vote request event"
    # TODO handle vote request event
    {:next_state, :candidate, state}
  end

  defunp election_timeout :: pos_integer do
    Enum.random(@min_election_timeout..@max_election_timeout)
  end

  defunp become_candidate(%State{term: term, peer: peer} = state) :: State.t do
    IO.puts "[Peer] #{inspect peer} became candidate"
    new_state = %State{state | term: term + 1}
    request_voting(new_state)
    new_state
  end

  defunp request_voting(%State{term: term, peer: peer} = state) :: State.t do
    request = %Raft.VoteRequest{term: term, from: peer}
    send_to_all_peers(state, request)
  end

  defp send_to_all_peers(%State{config: %Raft.Config{peers: peers}}, event) do
    Enum.each(peers, fn %Raft.Peer{node_name: node_name, name: peer_name} = peer ->
      try do
        Node.spawn(node_name, fn -> :gen_fsm.send_all_state_event(peer_name, event) end)
      rescue
        ArgumentError -> IO.inspect "could not send #{inspect(event)} to #{inspect peer}"
      end
    end)
  end
end
