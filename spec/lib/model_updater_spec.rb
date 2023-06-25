require "rails_helper"

RSpec.describe ModelUpdater do
  it "it has a version number" do
    expect(ModelUpdater::VERSION).to be_truthy
    expect(ModelUpdater::Engine).to be_truthy
    expect(ModelUpdater::Proxy).to be_truthy
    expect(ModelUpdater::DefinitionProxy.new("aurora")).to be_truthy
  end
end
