use Croma

defmodule Raft.Election do
  @min_timeout   500
  @max_timeout 1_000

  defun timeout :: pos_integer do
    Enum.random(@min_timeout..@max_timeout)
  end
end
