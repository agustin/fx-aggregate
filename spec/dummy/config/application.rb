require File.expand_path("../boot", __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"

Bundler.require(*Rails.groups)
require "fx-aggregate"

module Dummy
  class Application < Rails::Application
    config.cache_classes = true
    config.eager_load = false
    config.active_support.deprecation = :stderr

    config.load_defaults 7.0

    if Rails.version >= "8.0"
      config.active_support.to_time_preserves_timezone = :zone
    end
  end
end
