defmodule Raft.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :raft,
      version:         "0.0.1",
      elixir:          "1.2.2",
      elixirc_options: [warnings_as_errors: true],
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps
    ]
  end

  def application do
    [
      applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
