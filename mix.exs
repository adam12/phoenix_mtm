defmodule PhoenixMTM.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_mtm,
     version: "0.3.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:phoenix_html, "~> 2.0"},
     {:ecto, "~> 2.0.0-rc"},
     {:ex_doc, ">= 0.0.0", only: :dev}]
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
