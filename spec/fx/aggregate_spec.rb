require "spec_helper"

RSpec.describe Fx::Aggregate do
  describe "#<=>" do
    it "delegates to `name`" do
      aggregate_a = Fx::Aggregate.new("name" => "name_a")
      aggregate_b = Fx::Aggregate.new("name" => "name_b")
      aggregate_c = Fx::Aggregate.new("name" => "name_c")

      expect(aggregate_b).to be_between(aggregate_a, aggregate_c)
    end
  end

  describe "#==" do
    it "compares `name`, `arguments` and `definition`" do
      aggregate_a = Fx::Aggregate.new(
        "name" => "name_a",
        "arguments" => "anyarray",
        "aggtransfn" => "array_append",
        "aggtranstype" => "anyelement"
      )
      aggregate_b = Fx::Aggregate.new(
        "name" => "name_b",
        "arguments" => "anyarray",
        "aggtransfn" => "array_append",
        "aggtranstype" => "anyelement"
      )

      expect(aggregate_a).not_to eq(aggregate_b)
    end
  end

  describe "#to_schema" do
    it "returns a schema compatible version of the aggregate" do
      aggregate = Fx::Aggregate.new(
        "name" => "median_aggregate",
        "arguments" => "anyelement",
        "aggtransfn" => "array_append",
        "aggtranstype" => "anyelement"
      )

      expect(aggregate.to_schema).to eq <<-EOS
  create_aggregate :median_aggregate, sql_definition: <<-\SQL
    CREATE AGGREGATE median_aggregate(anyelement)(
      SFUNC = array_append,
      STYPE = anyelement
    );
  SQL
      EOS
    end
  end
end
