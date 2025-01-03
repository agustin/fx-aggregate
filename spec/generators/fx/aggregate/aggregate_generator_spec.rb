require "spec_helper"
require "generators/fx/aggregate/aggregate_generator"

RSpec.describe Fx::Generators::AggregateGenerator, :generator do
  it "creates a aggregate definition file, and a migration" do
    migration = file("db/migrate/create_aggregate_test.rb")
    aggregate_definition = file("db/aggregates/test_v01.sql")

    run_generator ["test"]

    expect(aggregate_definition).to exist
    expect(migration).to be_a_migration
    expect(migration_file(migration)).to contain("CreateAggregateTest")
  end

  context "when passed --no-migration" do
    it "creates a only aggregate definition file" do
      migration = file("db/migrate/create_aggregate_test.rb")
      aggregate_definition = file("db/aggregates/test_v01.sql")

      run_generator ["test", "--no-migration"]

      expect(aggregate_definition).to exist
      expect(Pathname.new(migration_file(migration))).not_to exist
    end
  end

  it "updates an existing aggregate" do
    with_aggregate_definition(
      name: "test",
      version: 1,
      sql_definition: "hello"
    ) do
      allow(Dir).to receive(:entries).and_return(["test_v01.sql"])
      migration = file("db/migrate/update_aggregate_test_to_version_2.rb")
      aggregate_definition = file("db/aggregates/test_v02.sql")

      run_generator ["test"]

      expect(aggregate_definition).to exist
      expect(migration).to be_a_migration
      expect(migration_file(migration))
        .to contain("UpdateAggregateTestToVersion2")
    end
  end
end
