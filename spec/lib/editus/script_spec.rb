require "rails_helper"

RSpec.describe Editus::Script do
  it do
    expect(Editus::Script.all).to eq({})
  end
end
