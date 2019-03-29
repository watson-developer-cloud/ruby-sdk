# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the watson_service
class WatsonServiceTest < Minitest::Test
  def test_wrong_username
    assert_raises do
      IBMWatson::AssistantV2.new(
        username: "\"username",
        password: "password"
      )
    end
  end

  def test_wrong_apikey
    assert_raises do
      IBMWatson::AssistantV1.new(
        iam_apikey: "{apikey"
      )
    end
  end

  def test_wrong_url
    assert_raises do
      IBMWatson::AssistantV1.new(
        iam_apikey: "apikey",
        url: "url}"
      )
    end
  end

  def test_correct_creds
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password"
    )
    refute_nil(service)
  end

  def test_set_credentials_from_path_in_env
    file_path = File.join(File.dirname(__FILE__), "../../resources/ibm-credentials.env")
    ENV["IBM_CREDENTIALS_FILE"] = file_path
    service = IBMWatson::AssistantV1.new(display_name: "Visual Recognition")
    assert_equal(service.url, "https://gateway.ronaldo.com")
    refute_nil(service)
    ENV.delete("IBM_CREDENTIALS_FILE")
  end

  def test_set_credentials_when_no_file
    service = IBMWatson::AssistantV1.new(display_name: "Visual Recognition")
    assert_equal(service.url, "https://gateway.watsonplatform.net/assistant/api")
    refute_nil(service)
  end
end
