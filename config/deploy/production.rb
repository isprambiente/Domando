# frozen_string_literal: true

server 'faq.intranet.isprambiente.it', user: 'domando', roles: %w[web app db]
set :deploy_to, '/home/domando/production'
set :rails_env, 'production'
set :branch, 'master'

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! 'config/settings/production.local.yml', "#{shared_path}/config/settings/production.yml"
      end
    end
  end
end