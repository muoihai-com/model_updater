require "rails_helper"

RSpec.describe Editus::Proxy do
  it do
    expect(Editus::Proxy.new(Editus)).to be_truthy
  end

  it do
    user = User.create name: "test", email: "example@gmail.com", age: 60
    proxy = Editus::RecordProxy.new(user)
    expect(proxy.type_of_col("created_at")).to eq(:datetime)
    expect{proxy.update_columns email: "aba@gg.com"}.to raise_error(Editus::UpdateFieldError)
  end

  it do
    allow_any_instance_of(Editus::Cop).to receive(:info).and_return({fields: []})
    proxy = Editus::Proxy.new(User)
    expect(proxy.column_names).to eq(%w[name email age created_at updated_at])
  end
end
