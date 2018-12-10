# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
# Prevent database truncation if the environment is production
require 'spec_helper'
ActiveRecord::Migration.maintain_test_schema!

# fix bug in stripe ruby mock
class Stripe::ListObject
  def has_more
    false
  end
end
