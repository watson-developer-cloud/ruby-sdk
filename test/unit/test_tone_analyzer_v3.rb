# frozen_string_literal: true

require_relative("./../../lib/watson_developer_cloud/tone_analyzer_v3.rb")
require_relative("./../../lib/watson_developer_cloud/watson_api_exception.rb")
require("json")
require("minitest/autorun")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Tone Analyzer V3 Service
class ToneAnalyzerV3Test < Minitest::Test
  def test_tone
    tone_response = JSON.parse(File.read(Dir.getwd + "/resources/tone-v3-expect1.json"))
    headers = {
      "Content-Type" => "application/json"
    }
    expected_response = DetailedResponse.new(status: 200, headers: headers, body: tone_response)
    tone_text = File.read(Dir.getwd + "/resources/personality.txt")
    stub_request(:post, "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?tones%5B%5D&version=2017-09-21")
      .with(
        body: tone_text,
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net:443"
        }
      ).to_return(status: 200, body: tone_response.to_json, headers: headers)
    service = ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: "username",
      password: "password"
    )
    service_response = service.tone(tone_input: tone_text, content_type: "application/json")
    assert(expected_response.status == service_response.status)
    assert(expected_response.body == service_response.body)
    expected_response.headers.each_key do |key|
      assert(service_response.headers.key?(key))
      assert(expected_response.headers[key] == service_response.headers[key])
    end
  end

  def test_tone_with_args
    tone_response = JSON.parse(File.read(Dir.getwd + "/resources/tone-v3-expect1.json"))
    headers = {
      "Content-Type" => "application/json"
    }
    tone_text = File.read(Dir.getwd + "/resources/personality.txt")
    expected_response = DetailedResponse.new(status: 200, headers: headers, body: tone_response)
    stub_request(:post, "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?sentences=false&tones%5B%5D&version=2017-09-21")
      .with(
        body: tone_text,
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net:443"
        }
      ).to_return(status: 200, body: tone_response.to_json, headers: headers)
    service = ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: "username",
      password: "password"
    )
    service_response = service.tone(tone_input: tone_text, content_type: "application/json", sentences: false)
    assert(expected_response.status == service_response.status)
    assert(expected_response.body == service_response.body)
    expected_response.headers.each_key do |key|
      assert(service_response.headers.key?(key))
      assert(expected_response.headers[key] == service_response.headers[key])
    end
  end

  def test_tone_chat
    tone_response = JSON.parse(File.read(Dir.getwd + "/resources/tone-v3-expect2.json"))
    headers = {
      "Content-Type" => "application/json"
    }
    expected_response = DetailedResponse.new(body: tone_response, status: 200, headers: headers)
    stub_request(:post, "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone_chat?version=2017-09-21")
      .with(
        body: "{\"utterances\":[{\"text\":\"I am very happy\",\"user\":\"glenn\"}]}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net:443"
        }
      ).to_return(status: 200, body: tone_response.to_json, headers: headers)
    service = ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: "username",
      password: "password"
    )
    utterances = [
      {
        "text" => "I am very happy",
        "user" => "glenn"
      }
    ]
    service_response = service.tone_chat(utterances: utterances)
    assert(expected_response.status == service_response.status)
    assert(expected_response.body == service_response.body)
    expected_response.headers.each_key do |key|
      assert(service_response.headers.key?(key))
      assert(expected_response.headers[key] == service_response.headers[key])
    end
  end

  def test_error
    error_code = 400
    error_message = "Invalid Json at line 2, column 12"
    headers = {
      "Content-Type" => "application/json"
    }
    tone_response = {
      "code" => error_code,
      "sub_code" => "C00012",
      "error" => error_message
    }
    text = "Team, I know that times are tough!"
    stub_request(:post, "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?tones%5B%5D&version=2017-09-21")
      .with(
        body: text,
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net:443"
        }
      ).to_return(status: 400, body: tone_response.to_json, headers: headers)
    service = ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: "username",
      password: "password"
    )
    begin
      service.tone(tone_input: text, content_type: "application/json")
    rescue WatsonApiException => e
      assert(e.code == error_code)
      assert(e.error == error_message)
      assert(e.info["sub_code"] == "C00012")
    end
  end
end
