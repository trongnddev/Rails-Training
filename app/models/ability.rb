# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    
    can :read, [Book, Category, Author]
    user ||= User.new

    if user.role == "admin" 
      can :manage, :all
    elsif user.role == "staff"
      can :crud, [Author, Book, AuthorBook, Category, Borrow, Publisher, Review]
      can [:read, :update], [User,], role: "user"
      can [:showborrow, :showreturn], Borrow
      
    elsif user.role == "user"

        can [:read, :update], User, id: user.id 
        can :read, [Book, Author, Publisher,Category,]
        can :create, [Borrow, Review]
        can [:update,:destroy], Borrow, user_id: user.id 
        can :read, Notification, user_id: user.id 
        can [:read,:showborrow, :showreturn],  Borrow
        can :index, Review
        can [:show, :destroy], Review, user_id: user.id   
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
