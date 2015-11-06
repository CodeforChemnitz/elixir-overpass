defmodule Overpass.Mixfile do
  use Mix.Project

  def project do
    [app: :overpass,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "Overpass",
     source_url: "https://github.com/CodeforChemnitz/elixir-overpass",
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
        {:httpoison, "~> 0.7.4"},
        {:sweet_xml, "~> 0.5.0"},
        {:jsx, "~> 2.8"},
        {:ex_doc, github: "elixir-lang/ex_doc"}
    ]
  end
end
