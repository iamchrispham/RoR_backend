class Developer < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Nameable
  include Indestructable
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :async
end
