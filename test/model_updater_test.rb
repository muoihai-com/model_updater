require 'test_helper'

class ModelUpdaterTest < ActiveSupport::TestCase
  test 'it has a version number' do
    assert Editus::VERSION
  end

  test 'Editus::Diploma.models' do
    assert_equal(Editus::Diploma.models, [])
  end

  test 'Editus::Diploma.model' do
    assert(Editus::Diploma.model('Editus'))
  end
end
