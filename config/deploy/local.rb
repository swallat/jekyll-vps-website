# Require our custom deployment strategy.
require "./config/deploy/local/file_strategy"

# Define a web server, where "vagrant" is our local SSH host and "deploy" is our
# server user created in part one.
server "vagrant", user: "deploy", roles: %w(web)

# Set our custom strategy.
set :git_strategy, FileStrategy

# Optionally define custom configuration files, where the staging version will
# overwrite the global version.
# set :configuration, "_config.yml,_config_staging.yml"
