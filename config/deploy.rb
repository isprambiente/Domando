# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "domando"
set :repo_url, "https://github.com/isprambiente/Domando.git"
set :deploy_to, '/home/domando'
set :rvm_ruby_version, '3.1.1@domando'

set :linked_files, fetch(:linked_files, []).push('config/master.key', 'config/credentials.yml.enc')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/sessions', 'tmp/state', 'vendor/bundle', 'public/system', 'config/settings', 'storage')
set :tmp_dir, '/home/domando/shared/tmp'

set :keep_releases, 5

before 'deploy:assets:precompile', 'deploy:yarn_install'
namespace :deploy do
  desc 'Run rake yarn install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! 'config/master.key', "#{shared_path}/config/master.key"
        upload! 'config/credentials.yml.enc', "#{shared_path}/config/credentials.yml.enc"
      end
    end
  end
end