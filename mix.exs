defmodule PhoenixMTM.Mixfile do
  use Mix.Project

  @source_url "https://github.com/adam12/phoenix_mtm"
  @version "1.0.0"

  def project do
    [
      app: :phoenix_mtm,
      name: "PhoenixMTM",
      version: @version,
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:phoenix_html, "~> 3.0"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0", [optional: true]},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:plug, ">= 0.0.0", only: :test}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description:
        "A small collection of functions to make it easier working " <>
          "with Ecto many_to_many associations and checkbox arrays.",
      maintainers: ["Adam Daniels"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/phoenix_mtm/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end
end
