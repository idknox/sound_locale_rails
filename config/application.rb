require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module SoundLocale
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.time_zone = 'Mountain Time (US & Canada)'
    config.active_record.default_timezone = :local  end
end
