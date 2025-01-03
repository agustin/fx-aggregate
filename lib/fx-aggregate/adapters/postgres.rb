require "fx-aggregate/adapters/postgres/aggregates"

module FxAggregate
  module Adapters
    module Postgres
      # Returns an array of aggregates in the database.
      #
      # This collection of aggregates is used by the [Fx::SchemaDumper] to
      # populate the `schema.rb` file.
      #
      # @return [Array<Fx::Aggregate>]
      def aggregates
        ::Fx::Adapters::Postgres::Aggregates.all(connection)
      end

      # Creates an aggregate in the database.
      #
      # This is typically called in a migration via
      # {Fx::Statements::Aggregate#create_aggregate}.
      #
      # @param sql_definition The SQL schema for the aggregate.
      #
      # @return [void]
      def create_aggregate(sql_definition)
        execute(sql_definition)
      end

      # # Updates an aggregate in the database.
      #
      # This is typically called in a migration via
      # {Fx::Statements::Aggregate#update_aggregate}.
      #
      # @param name The name of the aggregate.
      # @param sql_definition The SQL schema for the aggregate.
      #
      # @return [void]
      def update_aggregate(name, sql_definition)
        drop_aggregate(name)
        create_aggregate(sql_definition)
      end

      # Drops the aggregate from the database
      #
      # This is typically called in a migration via
      # {Fx::Statements::Aggregate#drop_aggregate}.
      #
      # @param name The name of the aggregate to drop
      #
      # @return [void]
      def drop_aggregate(name)
        defs = aggregates.select { |aggregate| aggregate.name == name.to_s }

        defs.each do |aggregate|
          execute "DROP AGGREGATE #{name}(#{aggregate.arguments});"
        end
        # execute "DROP AGGREGATE #{name}();"
      end
    end
  end
end
