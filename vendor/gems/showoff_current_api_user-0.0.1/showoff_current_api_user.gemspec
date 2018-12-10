# -*- encoding: utf-8 -*-
# stub: showoff_current_api_user 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "showoff_current_api_user".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Showoff".freeze]
  s.date = "2016-07-13"
  s.description = "Helper for storing/retrieving a current_api_user.".freeze
  s.email = ["hello@showoff.ie".freeze]
  s.homepage = "http://www.showoff.ie".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Helper for storing/retrieving a current_api_user.".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_runtime_dependency(%q<request_store>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_dependency(%q<request_store>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
    s.add_dependency(%q<request_store>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
  end
end

