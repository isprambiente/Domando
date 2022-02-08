class UserFaq < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: :user_id, primary_key: :id, required: true
  belongs_to :faq, class_name: 'Faq', foreign_key: :faq_id, primary_key: :id, required: true

  validates_uniqueness_of :faq_id, scope: :user_id
end
