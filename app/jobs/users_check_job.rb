# frozen_string_literal: true

# This job contain the methods for sync users with REST-API json
class UsersCheckJob < ApplicationJob
  queue_as :urgent
  require 'open-uri'

  # get users data from remote api.
  # For each user received run {set_data}
  def perform(username: '')
    return if Rails.env.test?

    users = User.all.order(label: :asc)
    users = users.where(username: username) if username.present?
    uri = URI.parse(Settings.api.url)
    opts = {
      http_basic_authentication: [
        Rails.application.credentials.api[:user] || Settings.api.username.to_s,
        Rails.application.credentials.api[:secret_access_key] || Settings.api.secret_access_key.to_s
      ],
      ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    users.each do |user|
      next if user.username.blank?

      uri.query = "login=#{user.username}&struttura=true"
      json_data = URI.parse(uri.to_s).open(opts).read
      user_data = JSON.parse(json_data)
      set_data(user, user_data)
      uri.query = ''
    end
  end

  # update a user with api data
  # @param [Object] user istance of user to update
  # @param [Hash] data all user's data from the api. Default: {}
  # @return [Boolean] true if user is updated
  def set_data(user, data = {})
    return if data.blank?

    user.label          = data['nominativo'].presence || [user.username.split('.').second, user.username.split('.').first].join(' ').titleize
    user.email          = data['email']
    user.structure      = data['assegnazione']
    user.responsabile   = data['struttura']['ufficio']['responsabile']['nominativi']
    user.locked_at      = Time.zone.today if !user.locked_at? && data['stato'] == 'scaduto'
    user.save
  end
end
