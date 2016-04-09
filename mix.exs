defmodule Dynamite.Mixfile do
  use Mix.Project

  def project do
    [app: :dynamite,
     version: "0.0.1",
     elixir: "> 1.0.0",
     deps: deps]
  end

  def application do
    [ applications: [:couchbeam, :cowboy, :ranch, :httpoison],
      env: [routing_table: []],
      mod: { Dynamite, [] }
    ]
  end

  defp deps do
    [ { :cowboy, "> 1.0.0" },
      { :couchbeam, git: "git://github.com/benoitc/couchbeam.git", tag: "master"},
			{ :poison, "~> 1.5" },
			{ :httpoison, "> 0.8.0" }]    
  end
end
