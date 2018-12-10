# -*- encoding: utf-8 -*-
# stub: concerning_services 0.0.24 ruby lib

Gem::Specification.new do |s|
  s.name = "concerning_services".freeze
  s.version = "0.0.24"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Showoff".freeze]
  s.date = "2017-07-21"
  s.description = "This gem provides conerns and services regularly used by Showoff.".freeze
  s.email = ["hello@showoff.ie".freeze]
  s.homepage = "http://www.showoff.ie".freeze
  s.rubygems_version = "2.6.12".freeze
  s.summary = "This gem provides conerns and services regularly used by Showoff.".freeze

  s.installed_by_version = "2.6.12" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_runtime_dependency(%q<paperclip>.freeze, [">= 5.0.0.beta2"])
      s.add_runtime_dependency(%q<aws-sdk>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<aws-sdk-core>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<geocoder>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<twilio>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<koala>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<showoff_sns>.freeze, [">= 0"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<ffaker>.freeze, [">= 0"])
      s.add_development_dependency(%q<capybara-webkit>.freeze, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>.freeze, [">= 0"])
      s.add_development_dependency(%q<formulaic>.freeze, [">= 0"])
      s.add_development_dependency(%q<launchy>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<timecop>.freeze, [">= 0"])
      s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_development_dependency(%q<awesome_print>.freeze, [">= 0"])
      s.add_development_dependency(%q<bullet>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler-audit>.freeze, [">= 0.5.0"])
      s.add_development_dependency(%q<factory_girl_rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<spring-commands-rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_dependency(%q<paperclip>.freeze, [">= 5.0.0.beta2"])
      s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
      s.add_dependency(%q<aws-sdk-core>.freeze, [">= 0"])
      s.add_dependency(%q<geocoder>.freeze, [">= 0"])
      s.add_dependency(%q<twilio>.freeze, [">= 0"])
      s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_dependency(%q<koala>.freeze, [">= 0"])
      s.add_dependency(%q<showoff_sns>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_dependency(%q<ffaker>.freeze, [">= 0"])
      s.add_dependency(%q<capybara-webkit>.freeze, [">= 0"])
      s.add_dependency(%q<database_cleaner>.freeze, [">= 0"])
      s.add_dependency(%q<formulaic>.freeze, [">= 0"])
      s.add_dependency(%q<launchy>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<timecop>.freeze, [">= 0"])
      s.add_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_dependency(%q<awesome_print>.freeze, [">= 0"])
      s.add_dependency(%q<bullet>.freeze, [">= 0"])
      s.add_dependency(%q<bundler-audit>.freeze, [">= 0.5.0"])
      s.add_dependency(%q<factory_girl_rails>.freeze, [">= 0"])
      s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
      s.add_dependency(%q<pry-rails>.freeze, [">= 0"])
      s.add_dependency(%q<spring-commands-rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
    s.add_dependency(%q<paperclip>.freeze, [">= 5.0.0.beta2"])
    s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk-core>.freeze, [">= 0"])
    s.add_dependency(%q<geocoder>.freeze, [">= 0"])
    s.add_dependency(%q<twilio>.freeze, [">= 0"])
    s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
    s.add_dependency(%q<koala>.freeze, [">= 0"])
    s.add_dependency(%q<showoff_sns>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    s.add_dependency(%q<ffaker>.freeze, [">= 0"])
    s.add_dependency(%q<capybara-webkit>.freeze, [">= 0"])
    s.add_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_dependency(%q<formulaic>.freeze, [">= 0"])
    s.add_dependency(%q<launchy>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<timecop>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
    s.add_dependency(%q<awesome_print>.freeze, [">= 0"])
    s.add_dependency(%q<bullet>.freeze, [">= 0"])
    s.add_dependency(%q<bundler-audit>.freeze, [">= 0.5.0"])
    s.add_dependency(%q<factory_girl_rails>.freeze, [">= 0"])
    s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
    s.add_dependency(%q<pry-rails>.freeze, [">= 0"])
    s.add_dependency(%q<spring-commands-rspec>.freeze, [">= 0"])
  end
end
