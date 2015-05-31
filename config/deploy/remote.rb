# Define a web server, where "example" is the name our new SSH host and
# "deploy" is our server user created via Chef.
server "example", user: "deploy", roles: %w(web)

# Support deploying a specific branch, but default to the master branch.
#
# For example, to deploy the "css-fixes" branch:
#   BRANCH=css-fixes cap remote deploy
#
set :branch, ENV["BRANCH"] || "master"

# Optionally define custom configuration files, where the production version
# will overwrite the global version.
# set :configuration, "_config.yml,_config_production.yml"
