require_relative("./../../core/watson-ruby/tone_analyzer_v3.rb")
require_relative("./../test_response_object.rb")
require("json")
require("minitest/autorun")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

class ToneAnalyzerV3Test < Minitest::Test
  def test_tone
    tone_response = JSON.parse(File.read(Dir.getwd + "/resources/tone-v3-expect1.json"))
    headers = {
      "Content-Type" => "application/json"
    }
    expected_response = DetailedResponse.new(TestResponseObject.new(status: 200, headers: headers, body: tone_response, is_testing: true))
    tone_text = File.read(Dir.getwd + "/resources/personality.txt")
    stub_request(:post, "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?tones%5B%5D&version=2017-09-21")
      .with(
        body: tone_text,
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net:443",
          "User-Agent" => "Faraday v0.15.2"
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

  # def test_tone_with_args
  #   tone_response = JSON.parse(File.read(Dir.getwd + "/resources/tone-v3-expect1.json"))
  #   headers
  # end
end
