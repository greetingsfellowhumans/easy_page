defmodule EasyPage.MixProject do
  use Mix.Project

  def project do
    [
      app: :easy_page,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:phoenix_html, ">= 4.0.0"},
      {:phoenix_live_reload, ">= 1.0.0", only: :dev},
      {:phoenix_live_view, ">= 1.0.0"}
    ]
  end
end
