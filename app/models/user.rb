# frozen_string_literal: true

# {User} is model responsible for storing user informations.
#
# @!attribute [rw] sign_in_count
#   @return [Integer] Counter of {User} sign in
# @!attribute [rw] current_sign_in_at
#   @return [DateTime] date of {User} current sign in
# @!attribute [rw] last_sign_in_at
#   @return [DateTime] date of {User} last sign in
# @!attribute [rw] current_sign_in_ip
#   @return [String] ip of {User} current sign in
# @!attribute [rw] last_sign_in_ip
#   @return [String] ip of {User} last sign in
# @!attribute [rw] locked_at
#   @return [Datetime] date when {User} was blocked
# @!attribute [rw] username
#   @return [String] unique {User} name
# @!attribute [rw] label
#   @return [String] long {User} name
# @!attribute [rw] admin
#   @return [Boolean[ true if {User} is a admin otherwise false
# @!attribute [rw] created_at
#   @return [DateTime] date when {User} was created
# @!attribute [rw] updated_at
#   @return [DateTime] date when {User} was updated
#
# === Relations
#
# === Validations
#
# * validate presence of {username}
# * validate presence of {label}
#
# === Before destroy
# {abort_destroy}
#
#
# @!method locked()
#   @return [Bool] if {User} with {locked_at} present
class User < ApplicationRecord
  store_accessor :metadata, :matr, :responsabile, :data_aggiornamento
  attr_accessor :forced

  devise Settings.auth.devise, :trackable, :timeoutable, :lockable

  default_scope { order(:label) }
  scope :avaibilities, -> { where(locked_at: nil) }
  scope :locked, -> { where.not(locked_at: nil) }
  scope :admins, -> { where(admin: true) }

  has_many :favorites, class_name: 'UserFaq', inverse_of: :user
  has_many :faqs, through: :favorites, source: :faq

  before_validation :presequisite
  before_destroy :abort_destroy, unless: :forced?
  validates :username, presence: true, uniqueness: true
  after_create_commit {UsersCheckJob.perform_now(username: username) unless Rails.env.test?}

  # update self with {locked_at} as Time.zone.now
  # @return [Boolean] true if is updated
  def disable!
    update(locked_at: Time.zone.now)
  end

  # update self with {locked_at} as nil
  # @return [Boolean] true if is updated
  def enable!
    update(locked_at: nil)
  end

  def locked?
    locked_at?
  end

  private

  def presequisite
    self.label = username if label.blank?
  end

  # is executed before destroy, add an error to :base and abort the action
  # @return [False]
  def abort_destroy
    errors.add :base, 'Can\'t be destroyed'
    throw :abort
  end

  def forced?
    forced == 'true'
  end
end
