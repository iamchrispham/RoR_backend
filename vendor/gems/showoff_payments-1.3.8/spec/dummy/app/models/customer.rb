class Customer < ActiveRecord::Base
  include Showoff::Payments::Customers::Customerable

  validates :email, presence: true, uniqueness: true, length: { minimum: 1 }

  def customerable_meta_data
    {
        email: email,
        first_name: 'First Name',
        last_name: 'Last Name'
    }
  end
end
