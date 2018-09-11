# frozen_string_literal: true

require_relative("./../../lib/ibm_watson/iam_token_manager.rb")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the IAM Token Manager
class IAMTokenManagerTest < Minitest::Test
  def test_request_token
    iam_url = "https://iam.bluemix.net/identity/token"
    response = {
      "access_token" => "oAeisG8yqPY7sFR_x66Z15",
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "expiration" => 1_524_167_011,
      "refresh_token" => "jy4gl91BQ"
    }

    token_manager = IAMTokenManager.new(
      iam_apikey: "iam_apikey",
      iam_access_token: "iam_access_token",
      iam_url: iam_url
    )
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_apikey", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: {})
    token_response = token_manager.send(:_request_token)
    assert_equal(response, token_response)
  end

  def test_refresh_token
    iam_url = "https://iam.bluemix.net/identity/token"
    response = {
      "access_token" => "oAeisG8yqPY7sFR_x66Z15",
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "expiration" => 1_524_167_011,
      "refresh_token" => "jy4gl91BQ"
    }
    token_manager = IAMTokenManager.new(
      iam_apikey: "iam_apikey",
      iam_access_token: "iam_access_token",
      iam_url: iam_url
    )
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "grant_type" => "refresh_token", "refresh_token" => "" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: {})
    token_response = token_manager.send(:_refresh_token)
    assert_equal(response, token_response)
  end

  def test_is_token_expired
    token_manager = IAMTokenManager.new(
      iam_apikey: "iam_apikey",
      iam_access_token: "iam_access_token",
      iam_url: "iam_url"
    )
    token_manager.token_info = {
      "access_token" => "oAeisG8yqPY7sFR_x66Z15",
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "expiration" => Time.now.to_i + 6000,
      "refresh_token" => "jy4gl91BQ"
    }

    refute(token_manager.send(:_is_token_expired?))
    token_manager.token_info["expiration"] = Time.now.to_i - 3600
    assert(token_manager.send(:_is_token_expired?))
  end

  def test_is_refresh_token_expired
    token_manager = IAMTokenManager.new(
      iam_apikey: "iam_apikey",
      iam_access_token: "iam_access_token",
      iam_url: "iam_url"
    )
    token_manager.token_info = {
      "access_token" => "oAeisG8yqPY7sFR_x66Z15",
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "expiration" => Time.now.to_i,
      "refresh_token" => "jy4gl91BQ"
    }

    refute(token_manager.send(:_is_refresh_token_expired?))
    token_manager.token_info["expiration"] = Time.now.to_i - (8 * 24 * 3600)
    assert(token_manager.send(:_is_token_expired?))
  end

  def test_get_token
    iam_url = "https://iam.bluemix.net/identity/token"
    token_manager = IAMTokenManager.new(
      iam_apikey: "iam_apikey",
      iam_url: iam_url
    )
    token_manager.user_access_token = "user_access_token"

    token = token_manager.token
    assert_equal(token_manager.user_access_token, token)

    response = {
      "access_token" => "hellohello",
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "expiration" => 1_524_167_011,
      "refresh_token" => "jy4gl91BQ"
    }
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_apikey", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: {})
    token_manager.user_access_token = ""
    token = token_manager.token
    assert_equal("hellohello", token)

    token_manager.token_info["expiration"] = Time.now.to_i - (20 * 24 * 3600)
    token = token_manager.token
    assert_equal("hellohello", token)

    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: {})
    token_manager.token_info["expiration"] = Time.now.to_i - 4000
    token = token_manager.token
    assert_equal("hellohello", token)

    token_manager.token_info = {
      "access_token" => "dummy",
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "expiration" => Time.now.to_i + 3600,
      "refresh_token" => "jy4gl91BQ"
    }
    token = token_manager.token
    assert_equal("dummy", token)
  end

  def test_dont_leak_constants
    assert_nil(defined? DEFAULT_IAM_URL)
    assert_nil(defined? CONTENT_TYPE)
    assert_nil(defined? ACCEPT)
    assert_nil(defined? DEFAULT_AUTHORIZATION)
    assert_nil(defined? REQUEST_TOKEN_GRANT_TYPE)
    assert_nil(defined? REQUEST_TOKEN_RESPONSE_TYPE)
    assert_nil(defined? REFRESH_TOKEN_GRANT_TYPE)
  end
end
