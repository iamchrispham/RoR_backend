class Vendor < ActiveRecord::Base
  include Showoff::Payments::Vendors::Vendorable


  def vendor_data
    {
        country: 'IE',
        email: email,
        tos_acceptance: {
            ip: '182.18.1.1',
            date: 1490980175
        }
    }

  end
end
