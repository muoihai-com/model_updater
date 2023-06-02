require "rails_helper"

RSpec.describe ModelUpdater::Proxy do
  it do
    expect(ModelUpdater::Proxy.new(ModelUpdater)).to be_truthy
  end
end
