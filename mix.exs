defmodule Project1.MixProject do
  use Mix.Project

  def project do
    [
      app: :project1,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env == :prod,
      escript: escript()

    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      Application.start(Project1),
      extra_applications: [:logger],
      mod: { Project1, []}
    ]
  end

  def escript do
    [main_module: Project1]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
