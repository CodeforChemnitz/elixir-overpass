defmodule Overpass.Mixfile do
  use Mix.Project

  def project do
    [app: :overpass,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
        {:httpoison, "~> 0.7.4"}
    ]
  end
end
