require 'test_helper'

module ModelUpdater
  class HomeControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should get index' do
      get root_url
      assert_response :success
    end
  end
end
