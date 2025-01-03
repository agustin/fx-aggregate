module DefinitionHelpers
  def with_aggregate_definition(name:, sql_definition:, version: 1, &block)
    definition = Fx::Definition.aggregate(name: name, version: version)

    with_definition(
      definition: definition,
      sql_definition: sql_definition,
      block: block
    )
  end

  def with_definition(definition:, sql_definition:, block:)
    FileUtils.mkdir_p(File.dirname(definition.full_path))
    File.write(definition.full_path, sql_definition)
    block.call
  ensure
    File.delete definition.full_path
  end
end

RSpec.configure do |config|
  config.include DefinitionHelpers
end
