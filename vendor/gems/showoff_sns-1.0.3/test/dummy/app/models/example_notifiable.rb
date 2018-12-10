class ExampleNotifiable < ActiveRecord::Base
  include Showoff::SNS::Notifiable
end
