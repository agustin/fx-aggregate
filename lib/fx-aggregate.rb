require "fx"

require "fx-aggregate/version"
require "fx-aggregate/adapters/postgres"
require "fx-aggregate/aggregate"
require "fx-aggregate/command_recorder"
require "fx-aggregate/definition"
require "fx-aggregate/statements"
require "fx-aggregate/schema_dumper"
require "fx-aggregate/railtie"

module FxAggregate
  def self.load
    Fx::Adapters::Postgres.include(FxAggregate::Adapters::Postgres)
    Fx::CommandRecorder.include(FxAggregate::CommandRecorder)
    Fx::Definition.include(FxAggregate::Definition)
    Fx::SchemaDumper.include(FxAggregate::SchemaDumper)
    Fx::Statements.include(FxAggregate::Statements)

    true
  end
end
