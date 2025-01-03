module FxAggregate
  module Definition
    AGGREGATE = "aggregate".freeze

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def aggregate(name:, version:)
        new(name: name, version: version, type: AGGREGATE)
      end
    end
  end
end
