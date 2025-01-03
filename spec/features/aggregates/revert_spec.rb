require "spec_helper"

RSpec.describe "Reverting migrations", :db do
  around do |example|
    sql_definition = <<~EOS
      CREATE OR REPLACE AGGREGATE test(anyelement)(
        sfunc = array_append,
        stype = anyarray,
        initcond = '{}'
      );
    EOS

    with_aggregate_definition(name: :test, sql_definition: sql_definition) do
      example.run
    end
  end

  it "can run reversible migrations for creating aggregates" do
    migration = Class.new(migration_class) do
      def change
        create_aggregate :test
      end
    end

    expect { run_migration(migration, [:up, :down]) }.not_to raise_error
  end

  it "can run reversible migrations for dropping aggregates" do
    connection.create_aggregate(:test)

    good_migration = Class.new(migration_class) do
      def change
        drop_aggregate :test, revert_to_version: 1
      end
    end
    bad_migration = Class.new(migration_class) do
      def change
        drop_aggregate :test
      end
    end

    expect { run_migration(good_migration, [:up, :down]) }.not_to raise_error
    expect { run_migration(bad_migration, [:up, :down]) }
      .to raise_error(
        ActiveRecord::IrreversibleMigration,
        /`create_aggregate` is reversible only if given a `revert_to_version`/
      )
  end

  it "can run reversible migrations for updating aggregates" do
    connection.create_aggregate(:test)

    sql_definition = <<-EOS
      CREATE OR REPLACE AGGREGATE test(anyelement)(
        sfunc = array_remove,
        stype = anyarray,
        initcond = '{}'
      );
    EOS

    with_aggregate_definition(
      name: :test,
      version: 2,
      sql_definition: sql_definition
    ) do
      migration = Class.new(migration_class) do
        def change
          update_aggregate :test, version: 2, revert_to_version: 1
        end
      end

      expect { run_migration(migration, [:up, :down]) }.not_to raise_error
    end
  end
end
