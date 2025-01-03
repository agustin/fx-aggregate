require "rails/railtie"

module FxAggregate
  # Automatically initializes Fx in the context of a Rails application when
  # ActiveRecord is loaded.
  #
  # @see Fx.load
  class Railtie < Rails::Railtie
    initializer "fx-aggregate.load", after: "fx.load" do
      ActiveSupport.on_load :active_record do
        FxAggregate.load
      end
    end
  end
end
