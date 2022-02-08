# frozen_string_literal: true

# {Faq} is model responsible for storing faq informations.
#
# @!attribute [rw] title
#   @return [String] Title of {Faq}
# @!attribute [rw] content
#   @return [Rich Text] content of {Faq}
# @!attribute [rw] structure
#   @return [CiText] structure of {Faq}
# @!attribute [rw] counter
#   @return [Integer] counter number of requests of {Faq}
# @!attribute [rw] visibility
#   @return [Integer] visibility enum with security visibility of {Faq}
# @!attribute [rw] approve
#   @return [Boolean] if {Faq} is approved
# @!attribute [rw] evidence
#   @return [Boolean] if {Faq} is in evidence
# @!attribute [rw] active
#   @return [Boolean] if {Faq} is active
# @!attribute [rw] metadata
#   @return [JSONB] content of {Faq}
# @!attribute [rw] created_at
#   @return [DateTime] date when {Faq} was created
# @!attribute [rw] updated_at
#   @return [DateTime] date when {Faq} was updated
#
# === Relations
#
# * acts_as_taggable_on :categories
# * has_rich_text :content
# * has_many_attached :files
# * has_many_attached :instructions
# * has_many_attached :models
# * has_many :favorites, class_name: 'UserFaq', inverse_of: :faq
# * has_many :users, through: :favorites, source: :user
#
# === Validations
#
# * validate presence of {title}
# * validate presence of {content}
# * validate presence of {categories}
#
class Faq < ApplicationRecord
  include PgSearch::Model
  acts_as_taggable_on :categories
  has_rich_text :content
  has_many_attached :files
  has_many_attached :instructions
  has_many_attached :models
  has_many :favorites, class_name: 'UserFaq', inverse_of: :faq
  has_many :users, through: :favorites, source: :user

  enum visibility: Settings.faq.visibility.to_hash

  store_accessor :metadata, :created_by, :updated_by, :approved_by

  scope :actived, -> { where(active: true) }
  scope :unactived, -> { where(active: false) }
  scope :approved, -> { where(approve: true) }
  scope :unapproved, -> { where(approve: false) }
  scope :evidenced, -> { where(evidence: true) }
  scope :on_top, ->(top = Settings.faq.top) { actived.approved.where("counter >= ?", 1).order(counter: :desc).limit(top) }
  pg_search_scope :search_by_title,
                    against: :title,
                    ignoring: :accents,
                    using: {
                      tsearch: { prefix: true, normalization: 2, any_word: true },
                      trigram: { threshold: 0.5, word_similarity: true },
                      dmetaphone: {}
                    },
                    order_within_rank: "faqs.counter DESC"

  before_validation :prerequisite
  validates :title, presence: true, uniqueness: true
  # validates :content, presence: true
  validates :structure, presence: true
  validates :visibility, presence: true
  validates_inclusion_of :visibility, in: visibilities.keys,
                                      message: "state must be one of #{visibilities.keys}"
  validate :must_have_valid_categories

  private

  def prerequisite
    self.created_by ||= Settings.system.username if created_by.blank? && new_record?
    self.updated_by ||= Settings.system.username
  end

  def must_have_valid_categories
    errors.add(:category_list, I18n.t('is_required', scope: '', default: "is required!")) if category_list.blank? && !Rails.env.test?
  end

end
