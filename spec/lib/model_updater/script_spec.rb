require "rails_helper"

RSpec.describe ModelUpdater::Script do
  it do
    expect(ModelUpdater::Script.all).to eq({})
  end
end
