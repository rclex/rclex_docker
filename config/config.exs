import Config

if config_env() == :dev do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix test"},
          {:cmd, "mix format --check-formatted"},
          {:cmd, "mix credo"}
        ]
      ]
    ]
end
