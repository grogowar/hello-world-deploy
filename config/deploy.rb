# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "hello-world"
set :repo_url, "git@github.com:grogowar/hello-world.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
append :linked_files, 'common/config/main-local.php'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, 'api/runtime', 'backend/runtime', 'frontend/runtime', 'frontend/web/uploads', 'vendor', 'console/runtime'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
    desc 'composer install'
    task :composer_install do
        on roles(:web) do
            within release_path do
                execute "cd #{release_path} && composer install"
            end
        end
    end

    desc 'apply migrations'
    task :migrate do
        on roles(:web) do
            within release_path do
                execute "cd #{release_path} && php yii migrate --interactive=0"
            end
        end
    end

    after :updated, 'deploy:composer_install'
    after :updated, 'deploy:migrate'

end