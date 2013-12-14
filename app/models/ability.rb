class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.persisted?
      can :crud, User, id: user.id
    end

    if user.admin? || user.owner?
      can :manage, Company, owner: user
      can :invite, User
      can :destroy, User, company: user.company
    end

    if user.admin?
      can :manage, :admin
      can :update, Proposal
    end
  end
end
