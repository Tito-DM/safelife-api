require 'test_helper'

class Api::V1::RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_request = api_v1_requests(:one)
  end

  test "should get index" do
    get api_v1_requests_url, as: :json
    assert_response :success
  end

  test "should create api_v1_request" do
    assert_difference('Api::V1::Request.count') do
      post api_v1_requests_url, params: { api_v1_request: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show api_v1_request" do
    get api_v1_request_url(@api_v1_request), as: :json
    assert_response :success
  end

  test "should update api_v1_request" do
    patch api_v1_request_url(@api_v1_request), params: { api_v1_request: {  } }, as: :json
    assert_response 200
  end

  test "should destroy api_v1_request" do
    assert_difference('Api::V1::Request.count', -1) do
      delete api_v1_request_url(@api_v1_request), as: :json
    end

    assert_response 204
  end
end
