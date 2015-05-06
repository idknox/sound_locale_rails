# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( utils.js )
Rails.application.config.assets.precompile += %w( event_ui.js )
Rails.application.config.assets.precompile += %w( google_map.js )
Rails.application.config.assets.precompile += %w( venues-map.js )
Rails.application.config.assets.precompile += %w( events-map.js )
Rails.application.config.assets.precompile += %w( venue-map.js )
Rails.application.config.assets.precompile += %w( events-index.js )
Rails.application.config.assets.precompile += %w( events-grid.js )
Rails.application.config.assets.precompile += %w( youtube.js )
Rails.application.config.assets.precompile += %w( soundcloud.js )
Rails.application.config.assets.precompile += %w( user-form.js )
Rails.application.config.assets.precompile += %w( venues-index.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
