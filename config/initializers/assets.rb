Rails.application.config.assets.version = (ENV['ASSETS_VERSION'] || '1.0')
Rails.application.config.assets.precompile += %w[consumer.js consumer.css]
Rails.application.config.assets.precompile += %w[business.js business.css]
Rails.application.config.assets.precompile += %w[footermanifest.js conversations.js email.css index.css pdf.css]
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'components', 'gentelella', 'production')
