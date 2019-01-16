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
end
