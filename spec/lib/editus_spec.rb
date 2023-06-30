require "rails_helper"

RSpec.describe Editus do
  it "it has a version number" do
    expect(Editus::VERSION).to be_truthy
    expect(Editus::Engine).to be_truthy
    expect(Editus::Proxy).to be_truthy
    expect(Editus::DefinitionProxy.new("aurora")).to be_truthy
    expect(Editus::Cop.valid_model_names).to match_array(%w[Admin User])
  end
end
