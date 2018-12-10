# -*- encoding: utf-8 -*-
# stub: showoff_sns 1.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "showoff_sns".freeze
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Showoff".freeze]
  s.date = "2017-08-23"
  s.description = "Exposes a simple interface to Amazon SNS. Provides a concern to allow models to become Nofitifiable.".freeze
  s.email = ["hello@showoff.ie".freeze]
  s.homepage = "http://www.showoff.ie".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "The Showoff::SNS gem uses Sidekiq which requires Redis be installed and running.".freeze
  s.rubygems_version = "2.6.12".freeze
  s.summary = "Exposes a simple interface to Amazon SNS.".freeze

  s.installed_by_version = "2.6.12" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["< 5.0.0", ">= 4.2.6"])
      s.add_runtime_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<aws-sdk>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<aws-sdk-core>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<active_model_serializers>.freeze, [">= 0.10.0"])
      s.add_runtime_dependency(%q<showoff_current_api_user>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<showoff_serializable>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<unicorn>.freeze, [">= 0"])
      s.add_development_dependency(%q<foreman>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, ["< 5.0.0", ">= 4.2.6"])
      s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
      s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
      s.add_dependency(%q<aws-sdk-core>.freeze, [">= 0"])
      s.add_dependency(%q<active_model_serializers>.freeze, [">= 0.10.0"])
      s.add_dependency(%q<showoff_current_api_user>.freeze, [">= 0"])
      s.add_dependency(%q<showoff_serializable>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<unicorn>.freeze, [">= 0"])
      s.add_dependency(%q<foreman>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["< 5.0.0", ">= 4.2.6"])
    s.add_dependency(%q<sidekiq>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk-core>.freeze, [">= 0"])
    s.add_dependency(%q<active_model_serializers>.freeze, [">= 0.10.0"])
    s.add_dependency(%q<showoff_current_api_user>.freeze, [">= 0"])
    s.add_dependency(%q<showoff_serializable>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda-matchers>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<unicorn>.freeze, [">= 0"])
    s.add_dependency(%q<foreman>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
  end
end
