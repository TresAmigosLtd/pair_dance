defmodule PairDance.MixProject do
  use Mix.Project

  def project do
    [
      app: :pair_dance,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: ["test.e2e": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PairDance.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cloak, "~> 1.1.2"},
      {:cloak_ecto, "~> 1.2.0"},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:ecto_soft_delete, "~> 2.0.2"},
      {:ecto_sql, "~> 3.11.1"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:finch, "~> 0.16"},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.23.0"},
      {:heroicons, "~> 0.5.3"},
      {:jason, "~> 1.4"},
      {:phoenix, "~> 1.7.6", override: true},
      {:phoenix_ecto, "~> 4.4.2"},
      {:phoenix_html, "~> 3.3.1"},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:phoenix_live_reload, "~> 1.4.1", only: :dev},
      {:phoenix_live_view, "~> 0.20.0"},
      {:plug_cowboy, "~> 2.6.1"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.14.3"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:ueberauth, "~> 0.10.5"},
      {:ueberauth_google, "~> 0.12.0"},
      {:wallaby, "~> 0.30.3", runtime: false, only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test --exclude feature"],
      "test.e2e": [
        "esbuild default",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test --only feature"
      ],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"],
      format: ["format", "formatAssets"],
      formatAssets: [
        "cmd ./assets/node_modules/.bin/prettier ./assets --ignore-path ./assets/.prettierignore --loglevel silent --write"
      ]
    ]
  end
end
