require 'test_helper'

class Api::V1::DonorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_donor = api_v1_donors(:one)
  end

  test "should get index" do
    get api_v1_donors_url, as: :json
    assert_response :success
  end

  test "should create api_v1_donor" do
    assert_difference('Api::V1::Donor.count') do
      post api_v1_donors_url, params: { api_v1_donor: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show api_v1_donor" do
    get api_v1_donor_url(@api_v1_donor), as: :json
    assert_response :success
  end

  test "should update api_v1_donor" do
    patch api_v1_donor_url(@api_v1_donor), params: { api_v1_donor: {  } }, as: :json
    assert_response 200
  end

  test "should destroy api_v1_donor" do
    assert_difference('Api::V1::Donor.count', -1) do
      delete api_v1_donor_url(@api_v1_donor), as: :json
    end

    assert_response 204
  end
end
