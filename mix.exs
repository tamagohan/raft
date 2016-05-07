defmodule Raft.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :raft,
      version:         "0.0.1",
      elixir:          "1.2.4",
      elixirc_options: [warnings_as_errors: true],
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps
    ]
  end

  def application do
    [
      mod:          {Raft, 5},
      applications: [:logger, :croma]
    ]
  end

  defp deps do
    [
      {:croma,   "0.4.3"},
      {:credo,   "0.3.13"},
      {:dialyze, "0.2.1", [only: :dev ]},
    ]
  end
end
