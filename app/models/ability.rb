class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.kind_of? Specialist
      user ||= Specialist.new

      can :manage, :b2c
      can :create, Entry
      can :update, Specialist, id: user.id
    else
      user ||= User.new

      can :manage, :b2b
      can :read, Entry
      can :update, User, id: user.id
      can :manage, Comment, user_id: user.id
      # can :read, :premium_data if user.company.premium?

      if user.owner?
        can :crud, Company, owner: user
        # can :crud, Payment, company: user.company
        # can :update_to_premium, Company, owner: user

        if user.company.premium?
          can :invite, User
          can :destroy, User, company: user.company
          can :signin_as, User, company: user.company
        end
      end
    end


    if user.moderator?
      can :manage, :admin
      can :update, Source
      can :crud, Entry
    end

    if user.admin?
      can :manage, :all
      # cannot :update_to_premium, Company
    end

  end
end
