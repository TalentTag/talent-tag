class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.persisted?
      can :manage, :b2c
      can :update, User, id: user.id
    end

    if user.company.present?
      can :manage, :b2b
      can :read, Entry
      can :manage, Comment, user_id: user.id
    end

    if user.owner?
      can :crud, Company, owner: user
      if user.company.premium?
        can :read, :premium_data
        can :invite, user
        can :destroy, User, company: user.company
        can :signin_as, User, company: user.company
      else
        can :update_to_premium, Company, owner: user
      end
    end

    if user.admin?
      can :manage, :all
    end

  end
end
