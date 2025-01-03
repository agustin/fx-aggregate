require "acceptance_helper"

RSpec.describe "User manages aggregates" do
  let(:function_template) do
    <<-SQL.freeze
      CREATE FUNCTION aggregate_test%1$d(arr anyarray)
      RETURNS BIGINT
      AS $$
        SELECT COUNT(*)
        FROM (
          SELECT "val" FROM unnest("arr") AS "val"
          GROUP BY 1
          HAVING COUNT(*) > %1$d
          ORDER BY 1
        ) AS "sub";
      $$ LANGUAGE 'sql' IMMUTABLE;
    SQL
  end

  let(:aggregate_template) do
    <<-SQL.freeze
      CREATE AGGREGATE aggregate_test(anyelement)(
        SFUNC = array_append,
        STYPE = anyarray,
        FINALFUNC = aggregate_test%1$d,
        INITCOND = '{}'
      );
    SQL
  end

  let(:test_query) do
    <<-SQL.freeze
      SELECT id, aggregate_test(id) AS computed
      FROM unnest('{1, 1, 2, 2, 2, 3}'::int[]) AS id
      GROUP BY id
    SQL
  end

  before(:each) do
    execute format(function_template, 1)
    execute format(function_template, 2)
  end

  after(:each) do
    execute "DROP AGGREGATE IF EXISTS aggregate_test(anyelement);"
    execute "DROP FUNCTION aggregate_test1(anyarray)"
    execute "DROP FUNCTION aggregate_test2(anyarray)"
  end

  it "handles simple aggregates" do
    successfully "rails generate fx:aggregate aggregate_test"
    write_aggregate_definition "aggregate_test_v01", format(aggregate_template, 1)
    successfully "rake db:migrate"

    result = ActiveRecord::Base.connection.execute(test_query)
    expect(result).to \
      match_array([
        {"id" => 1, "computed" => 1},
        {"id" => 2, "computed" => 1},
        {"id" => 3, "computed" => 0}
      ])

    successfully "rails generate fx:aggregate aggregate_test"
    verify_identical_definitions(
      "db/aggregates/aggregate_test_v01.sql",
      "db/aggregates/aggregate_test_v02.sql"
    )
    write_aggregate_definition "aggregate_test_v02", format(aggregate_template, 2)
    successfully "rake db:migrate"

    result = ActiveRecord::Base.connection.execute(test_query)
    expect(result).to \
      match_array([
        {"id" => 1, "computed" => 0},
        {"id" => 2, "computed" => 1},
        {"id" => 3, "computed" => 0}
      ])
  end
end
