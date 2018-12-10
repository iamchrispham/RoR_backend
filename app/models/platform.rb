class Platform < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Showoff::Concerns::Imagable
  include Indestructable

  has_many :credit_records, as: :creditor

  translates :name
  validates :name, presence: true

  def password_required?
    false
  end

end
