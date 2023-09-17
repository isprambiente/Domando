# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    # Guest user can read, list and propose a Faq if this is approved, actived and has a public visibility
    can %i[read list search search_by_title], Faq, approve: true, active: true, visibility: 0
    # can :create, Faq, approve: false
    if user.present?
      can %i[propose propose_send favorite favorite_list favorite_create favorite_destroy], Faq, approve: true, active: true
      # Auhenticated user can has all guest ability and can read and list a Faq if this is approved, actived and has a restricted visibility
      can %i[read list], Faq, approve: true, active: true, visibility: 1
      # Auhenticated user can has all guest ability and can read and list a Faq if this is approved, actived and has a restricted visibility for user structure
      can %i[read list], Faq, approve: true, active: true, visibility: 2, structure: user.structure
      if user.admin?
        # Admin user can manage all Models
        can :manage, :all
      elsif user.editor?
        # Editor user can only manage the faqs of his structure
        can :manage, Faq, structure: user.structure
      end
    end
  end
end
