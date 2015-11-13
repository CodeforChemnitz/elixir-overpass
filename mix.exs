defmodule Overpass.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :overpass,
     version: @version,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "Elixir-Overpass",
     source_url: "https://github.com/CodeforChemnitz/elixir-overpass",
     description: description,
     package: package,
     deps: deps,
     docs: [ extras: ["README.md"],
             source_ref: "v#{@version}",
             source_url: "https://github.com/CodeforChemnitz/elixir-overpass"
           ]
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
        {:httpoison, "~> 0.7.4"},
        {:sweet_xml, "~> 0.5.0"},
        {:jsx, "~> 2.8"},

        # Doc
        {:inch_ex, "~> 0.4.0", only: :dev},
        {:earmark, "~> 0.1.19", only: :dev},
        {:ex_doc, "~> 0.10.0", only: :dev},

        # Dev
        {:dogma, "~> 0.0.11", only: :dev},
    ]
  end

  defp description do
      """
      A Elixir wrapper to access the Overpass API.
      """
  end

  defp package do
    [# These are the default files included in the package
      maintainers: ["Tobias Gall", "Ronny Hartenstein"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/CodeforChemnitz/elixir-overpass",
               "Docs" => "http://codeforchemnitz.de/elixir-overpass/doc/"}]
  end

end
