defmodule ElixirBasics.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_basics,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      check: ["dialyzer"],
      start: ["collections"],
      basics: ["run_lesson basics"],
      functions: ["run_lesson functions"],
      control_flow: ["run_lesson control_flow"],
      collections: ["run_lesson collections"]
    ]
  end
end
