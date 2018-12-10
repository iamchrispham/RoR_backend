class UserLogin < ActiveRecord::Base
  include Indestructable

  serialize :request, JSON

  belongs_to :user
  belongs_to :application, class_name: 'Doorkeeper::Application', foreign_key: 'application_id'
  belongs_to :access_token, class_name: 'Doorkeeper::AccessToken', foreign_key: 'access_token_id'

  validates :user, presence: true

  after_create :send_user_login

  def platform
    browser_from_agent.platform.name
  end

  def device
    browser_from_agent.device.name
  end

  def browser
    browser_from_agent.name
  end

  def revoked?
    return access_token.revoked? if access_token.present?
    return true if access_token.blank?
  end

  def revoke!
    access_token.revoke if access_token.present?
  end

  private
  def browser_from_agent
    Browser.new(user_agent, accept_language: "en-us")
  end

  def send_user_login
    # TODO: Turn this back on when client wants it
    # UserMailer.delay.account_login(id)
  end
end
