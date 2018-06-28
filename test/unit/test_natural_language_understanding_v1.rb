# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Natural Language Understanding V1 Service
class NaturalLanguageUnderstandingV1Test < Minitest::Test
  def test_text_analyze
    service = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze?version=2018-03-16")
      .with(
        body: "{\"features\":{\"sentiment\":{}},\"text\":\"hello this is a test\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.analyze(
      features: {
        sentiment: {}
      },
      text: "hello this is a test"
    )
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_html_analyze
    service = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze?version=2018-03-16")
      .with(
        body: "{\"features\":{\"sentiment\":{},\"emotion\":{\"document\":false}},\"html\":\"<span>hello this is a test </span>\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.analyze(
      features: {
        sentiment: {},
        emotion: {
          document: false
        }
      },
      html: "<span>hello this is a test </span>"
    )
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_url_analyze
    service = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze?version=2018-03-16")
      .with(
        body: "{\"features\":{\"sentiment\":{},\"emotion\":{\"document\":false}},\"url\":\"http://cnn.com\",\"xpath\":\"/bogus/xpath\",\"language\":\"en\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.analyze(
      features: {
        sentiment: {},
        emotion: {
          document: false
        }
      },
      url: "http://cnn.com",
      xpath: "/bogus/xpath",
      language: "en"
    )
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_list_models
    service = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/models?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_models
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_delete_model
    model_id = "invalid_model_id"
    service = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/models/invalid_model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { deleted: model_id }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_model(
      model_id: model_id
    )
    assert_equal({ "deleted" => model_id }, service_response.body)
  end
end
