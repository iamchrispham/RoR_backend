# -*- encoding: utf-8 -*-
# stub: showoff_api 0.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "showoff_api".freeze
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Showoff".freeze]
  s.date = "2016-08-05"
  s.description = "Provides common functionality for Showoff APIs".freeze
  s.email = ["hello@showoff.ie".freeze]
  s.homepage = "http://www.showoff.ie".freeze
  s.post_install_message = "Version 0.0.7 changes how examples are handled. You will need to run your examples again.\nIf your documentation was previously accessed at /api/documentation/1, it will now be available at /api/documentation/v1".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Provides common functionality for Showoff APIs".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_runtime_dependency(%q<apipie-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<unicorn>.freeze, [">= 0"])
      s.add_development_dependency(%q<foreman>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
      s.add_dependency(%q<apipie-rails>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<unicorn>.freeze, [">= 0"])
      s.add_dependency(%q<foreman>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["~> 4.2.6"])
    s.add_dependency(%q<apipie-rails>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<unicorn>.freeze, [">= 0"])
    s.add_dependency(%q<foreman>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
  end
end

