module FxAggregate
  module SchemaDumper
    def tables(stream)
      super
      aggregates(stream)
    end

    private

    def aggregates(stream)
      if dumpable_aggregates_in_database.any?
        stream.puts
      end

      dumpable_aggregates_in_database.each do |aggregate|
        stream.puts(aggregate.to_schema)
      end
    end

    def dumpable_aggregates_in_database
      @_dumpable_aggregates_in_database ||= Fx.database.aggregates
    end
  end
end
