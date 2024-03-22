require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "capistrano/rails"
require "capistrano/bundler"
require "capistrano/rvm"

require "capistrano/puma"
install_plugin Capistrano::Puma, load_hooks: false   # Default puma tasks
install_plugin Capistrano::Puma::Systemd

require "capistrano/sidekiq"
# install_plugin Capistrano::Sidekiq  # Default sidekiq tasks
# install_plugin Capistrano::Sidekiq::Systemd # Then select your service manager

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
