defmodule PhoenixMTM.Mixfile do
  use Mix.Project

  @version "0.5.1"

  def project do
    [
      app: :phoenix_mtm,
      version: @version,
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "PhoenixMTM",
      docs: [
        extras: ["README.md", "CHANGELOG.md"],
        main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/adam12/phoenix_mtm"
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:phoenix_html, "~> 2.0"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0", [optional: true]},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    A small collection of functions to make it easier working with Ecto
    many_to_many assocations and checkbox arrays.
    """
  end

  defp package do
    [
      maintainers: ["Adam Daniels"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/adam12/phoenix_mtm"}
    ]
  end
end
