class UsersFollowedCompany < ActiveRecord::Base
  validates :company_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :company
end
