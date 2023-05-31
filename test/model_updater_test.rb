require 'test_helper'

class ModelUpdaterTest < ActiveSupport::TestCase
  test 'it has a version number' do
    assert ModelUpdater::VERSION
  end

  test 'ModelUpdater::Diploma.models' do
    assert_equal(ModelUpdater::Diploma.models, [])
  end

  test 'ModelUpdater::Diploma.model' do
    assert(ModelUpdater::Diploma.model('ModelUpdater'))
  end
end
