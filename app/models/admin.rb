class Admin < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Nameable
  include Indestructable

  resourcify
  rolify role_cname: 'AdminRole'

  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :async, :invitable

  def current_role
    roles.first.name.downcase.to_sym if roles.count > 0
  end

  def status
    return :deactivated unless active
    return :active if active && invitation_token.blank?
    return :invited if invitation_token.present?
  end

  def status_class
    case status
      when :deactivated
        'danger'
      when :active
        'success'
      when :invited
        'warning'
    end
  end

  def active?
    active
  end

  def invited?
    status == :invited
  end

  #events
  def events
    Event.all
  end

  #users
  def users
    User.all
  end

  #tickets
  def tickets
    EventTicketDetail.all
  end

end
