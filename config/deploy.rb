# Lock the Capistrano version to ensure we're running the version we expect.
lock "3.4.0"

# Application name and deployment location.
#
# The repository URL is not used locally, so no need to change it yet. The
# deployment location and application name are from the name used in part one
# of the series, so be sure to update if you used a different name.
set :repo_url,    "https://github.com/tristandunn/jekyll-vps-website.git"
set :deploy_to,   "/var/www/example.com"
set :application, "example"

# Ensure bundler runs for the web role.
set :bundle_roles, :web

# Location and settings for rbenv environment.
set :rbenv_type,        :system
set :rbenv_ruby,        "2.1.5"
set :rbenv_roles,       :all
set :rbenv_map_bins,    %w(bundle gem rake ruby)
set :rbenv_custom_path, "/opt/rbenv"

# Don't keep any previous releases.
set :keep_releases, 1

# Avoid UTF-8 issues when building Jekyll.
set :default_env, { "LC_ALL" => "en_US.UTF-8" }

# Define a custom Jekyll build task and run it before publishing the website. It
# allows for a custom configuration setting per environment, which is helpful
# for customizing settings in production.
namespace :deploy do
  desc "Build the website with Jekyll"
  task :build do
    on roles(:web) do
      within release_path do
        execute :bundle, "exec", "jekyll", "build", "--config",
          fetch(:configuration, "_config.yml")
      end
    end
  end

  before :publishing, :build
end

# Don't log revisions.
Rake::Task["deploy:log_revision"].clear_actions
