require "spec_helper"

RSpec.describe FxAggregate do
  it "has a version number" do
    expect(FxAggregate::VERSION).to be_present
  end

  it "loads aggregate modules into Fx" do
    expect(Fx::Adapters::Postgres).to include(FxAggregate::Adapters::Postgres)
    expect(Fx::CommandRecorder).to include(FxAggregate::CommandRecorder)
    expect(Fx::Definition).to include(FxAggregate::Definition)
    expect(Fx::SchemaDumper).to include(FxAggregate::SchemaDumper)
    expect(Fx::Statements).to include(FxAggregate::Statements)
  end
end
