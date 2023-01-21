lock "~> 3.17.1"

server '104.131.40.131', port: 22, roles: [:web, :app, :db], primary: true
set :application, "dizauto"
set :repo_url, "git@github.com:stap780/dizauto.git"

set :user, 'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :pty,             true
set :stage,           :production
set :deploy_to,       "/var/www/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

append :linked_files, "config/master.key", "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "public", 'tmp/sockets', 'vendor/bundle', 'lib/tasks', 'lib/drop', 'storage'




# namespace :rails do
#     desc "Remote console"
    
#     task :console do
#         puts "Remote console"
#       on roles(:app) do
#         puts "task :console "
#         exec %Q(ssh deploy@104.131.40.131 -t "bash --login -c 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} bundle exec rails c'")
#         # run_interactively("RAILS_ENV=#{fetch(:rails_env)} bundle exec rails c","deploy")
#       end
#     end
  
#     # desc "Remote dbconsole"
#     # task :dbconsole do
#     #     on roles(:app) do |h|
#     #         run_interactively("RAILS_ENV=#{fetch(:rails_env)} bundle exec rails dbconsole","deploy")
#     #     end
#     # end
# end

# def run_interactively(command, user)
#     puts "Running `#{command}` as #{user}@#104.131.40.131"
#     exec %Q(ssh deploy@104.131.40.131 -t "bash --login -c 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} bundle exec rails c'")
# end    
  