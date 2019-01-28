# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      set_admin_abilities(user)
    elsif user.is_a?(Developer)
      set_developer_abilities(user)
    end
  end

  private

  def set_admin_abilities(user)
    cannot :manage, :all
    if user.has_role?(:admin) || user.has_role?(:sales) || user.has_role?(:help_desk)
      can :read, User
      can :read, GeneralNotification

      can :read, Event

      can :read, Report

      can :read, SpecialOffer

      can :read, Group
    end

    if user.has_role? :admin

      can :manage, Admin

      can :manage, UserLogin
      can :manage, User

      can :manage, Event

      can :manage, GeneralNotification

      can :read, :revenues

      can %i[read manage], Report

      can :manage, SpecialOffer

      can :manage, Group

    elsif user.has_role? :sales
      not_super_admin_user_permissions(user)

    elsif user.has_role?(:help_desk)
      not_super_admin_user_permissions(user)
    end
  end

  def set_developer_abilities(user)
    cannot :manage, :all
    can :manage, :objects
    can :manage, Doorkeeper::Application

    cannot :manage, Developer
    can %i[read update], Developer, id: user.id
  end

  def not_super_admin_user_permissions(user)
    cannot :manage, Admin
    can %i[read update], Admin, id: user.id
  end
end
