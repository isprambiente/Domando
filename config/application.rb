# frozen_string_literal: true

require_relative "boot"

require 'rails/all'
require 'rack-cas/session_store/active_record'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Domando
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.rack_cas.session_store = RackCAS::ActiveRecordStore
    config.rack_cas.server_url = Settings.auth.url
    config.encoding = 'utf-8'
    config.i18n.default_locale = :it
    config.i18n.available_locales = [:it]
    config.i18n.enforce_available_locales = true
    config.i18n.fallbacks = true
    config.time_zone = 'Rome'
    config.generators do |g|
      g.template_engine :haml
    end
    # Don't generate system test files.
    # config.generators.system_tests = nil
  end
end
