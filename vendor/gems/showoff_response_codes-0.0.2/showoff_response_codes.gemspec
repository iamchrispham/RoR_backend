# -*- encoding: utf-8 -*-
# stub: showoff_response_codes 0.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "showoff_response_codes".freeze
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Dever".freeze]
  s.date = "2016-07-14"
  s.description = "Response Codes to be used in Showoff API Applications.".freeze
  s.email = ["michael@showoff.ie".freeze]
  s.homepage = "http://www.showoff.ie".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Response Codes to be used in Showoff API Applications.".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
  end
end

