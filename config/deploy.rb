# config/deploy.rb
lock "~> 3.17.0"

set :application, "blog_app"
set :repo_url, "git@github.com:jamo254/blog_app.git" # Replace with your Git repository URL

set :deploy_to, "/home/deploy/apps/#{fetch(:application)}"

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :rbenv_type, :user
set :rbenv_ruby, '3.2.2' # Replace with your Ruby version

set :puma_threads, [4, 16]
set :puma_workers, 0
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# Uncomment this if you're using Sidekiq
# set :sidekiq_config, "#{current_path}/config/sidekiq.yml"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  after :publishing, :restart
end