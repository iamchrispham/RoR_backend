# -*- encoding: utf-8 -*-
# stub: showoff_payments 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "showoff_payments".freeze
  s.version = "1.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Showoff".freeze]
  s.date = "2016-11-01"
  s.description = "Showoff Payments Framework".freeze
  s.email = ["hello@showoff.ie".freeze]
  s.homepage = "http://www.showoff.ie".freeze
  s.licenses = ["Copyright Showoff".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Showoff Payments Framework".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_runtime_dependency(%q<active_model_serializers>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<stripe>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<concerning_services>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>.freeze, [">= 0"])
      s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
      s.add_development_dependency(%q<factory_girl_rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<stripe-ruby-mock>.freeze, [">= 0"])
      s.add_development_dependency(%q<activerecord-tableless>.freeze, [">= 0"])
      s.add_development_dependency(%q<showoff_serializable>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_dependency(%q<active_model_serializers>.freeze, [">= 0"])
      s.add_dependency(%q<stripe>.freeze, [">= 0"])
      s.add_dependency(%q<concerning_services>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_dependency(%q<database_cleaner>.freeze, [">= 0"])
      s.add_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
      s.add_dependency(%q<factory_girl_rails>.freeze, [">= 0"])
      s.add_dependency(%q<stripe-ruby-mock>.freeze, [">= 0"])
      s.add_dependency(%q<activerecord-tableless>.freeze, [">= 0"])
      s.add_dependency(%q<showoff_serializable>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
    s.add_dependency(%q<active_model_serializers>.freeze, [">= 0"])
    s.add_dependency(%q<stripe>.freeze, [">= 0"])
    s.add_dependency(%q<concerning_services>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    s.add_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
    s.add_dependency(%q<factory_girl_rails>.freeze, [">= 0"])
    s.add_dependency(%q<stripe-ruby-mock>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord-tableless>.freeze, [">= 0"])
    s.add_dependency(%q<showoff_serializable>.freeze, [">= 0"])
  end
end
