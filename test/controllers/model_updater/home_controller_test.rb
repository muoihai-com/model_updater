require 'test_helper'

module Editus
  class HomeControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should get index' do
      get root_url
      assert_response :success
    end
  end
end
