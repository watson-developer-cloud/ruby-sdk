# frozen_string_literal: true

require_relative("./../../core/watson-ruby/watson_assistant_v1.rb")
require("json")
require("minitest/autorun")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Watson Assistant V1 Service
class AssistantV1Test < Minitest::Test
  def test_plain_to_json
    response = {
      "text" => "I want financial advice today.",
      "created" => "2016-07-11T16:39:01.774Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    expected_response = DetailedResponse.new(status: 201, body: response, headers: headers)
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples?version=2018-02-16")
      .with(
        body: "{\"text\":\"I want financial advice today.\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net:443"
        }
      ).to_return(status: 201, body: response.to_json, headers: headers)
    service = AssistantV1.new(
      version: "2018-02-16",
      username: "username",
      password: "password"
    )
    service_response = service.create_counterexample(
      workspace_id: "boguswid",
      text: "I want financial advice today."
    )
    assert(expected_response.status == service_response.status)
    assert(expected_response.body == service_response.body)
    expected_response.headers.each_key do |key|
      assert(service_response.headers.key?(key))
      assert(expected_response.headers[key] == service_response.headers[key])
    end
  end
end
