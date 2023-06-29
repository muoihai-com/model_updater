require "rails_helper"

RSpec.describe ModelUpdater::Proxy do
  it do
    expect(ModelUpdater::Proxy.new(ModelUpdater)).to be_truthy
  end

  it do
    user = User.create name: "test", email: "example@gmail.com", age: 60
    proxy = ModelUpdater::RecordProxy.new(user)
    expect{proxy.update_columns email: "aba@gg.com"}.to raise_error(ModelUpdater::UpdateFieldError)
  end
end
