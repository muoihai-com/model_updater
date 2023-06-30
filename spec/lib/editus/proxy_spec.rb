require "rails_helper"

RSpec.describe Editus::Proxy do
  it do
    expect(Editus::Proxy.new(Editus)).to be_truthy
  end

  it do
    user = User.create name: "test", email: "example@gmail.com", age: 60
    proxy = Editus::RecordProxy.new(user)
    expect{proxy.update_columns email: "aba@gg.com"}.to raise_error(Editus::UpdateFieldError)
  end
end
