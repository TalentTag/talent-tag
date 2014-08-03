class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.persisted? # specialists
      can :manage, :b2c
      can :create, Entry
      can :update, User, id: user.id
    end

    if user.company.present? # owners & employee
      can :manage, :b2b
      can :read, Entry
      can :manage, Comment, user_id: user.id
      can :read, :premium_data if user.company.premium?
    end

    if user.owner? # owners
      can :crud, Company, owner: user
      can :update_to_premium, Company, owner: user
      if user.company.premium?
        can :invite, User
        can :destroy, User, company: user.company
        can :signin_as, User, company: user.company
      end
    end

    if user.moderator?
      can :manage, :admin
      can :update, Source
      can :crud, Entry
    end

    if user.admin? # admins
      can :manage, :all
      cannot :update_to_premium, Company
      cannot :extend_premium, Company
    end

  end
end
