# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Natural Language Understanding V1 Service
class NaturalLanguageUnderstandingV1Test < Minitest::Test
  def test_text_analyze
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )
    stub_request(:post, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/analyze?version=2018-03-16")
      .with(
        body: "{\"features\":{\"sentiment\":{}},\"text\":\"hello this is a test\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.analyze(
      features: {
        sentiment: {}
      },
      text: "hello this is a test"
    )
    assert_equal({ "resulting_key" => true }, service_response.result)
  end

  def test_html_analyze
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )
    stub_request(:post, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/analyze?version=2018-03-16")
      .with(
        body: "{\"features\":{\"sentiment\":{},\"emotion\":{\"document\":false}},\"html\":\"<span>hello this is a test </span>\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
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
    assert_equal({ "resulting_key" => true }, service_response.result)
  end

  def test_url_analyze
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )
    stub_request(:post, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/analyze?version=2018-03-16")
      .with(
        body: "{\"features\":{\"sentiment\":{},\"emotion\":{\"document\":false}},\"url\":\"http://cnn.com\",\"xpath\":\"/bogus/xpath\",\"language\":\"en\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
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
    assert_equal({ "resulting_key" => true }, service_response.result)
  end

  def test_list_models
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )
    stub_request(:get, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_models
    assert_equal({ "resulting_key" => true }, service_response.result)
  end

  def test_delete_model
    model_id = "invalid_model_id"
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )
    stub_request(:delete, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/invalid_model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { deleted: model_id }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_model(
      model_id: model_id
    )
    assert_equal({ "deleted" => model_id }, service_response.result)
  end

  def test_sentiment_models
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )

    stub_request(:post, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/sentiment?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    service_response = service.create_sentiment_model(
      language: "en",
      training_data: training_data
    )
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:get, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/sentiment?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_sentiment_models
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:get, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/sentiment/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_sentiment_model(model_id: "model_id")
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:put, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/sentiment/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    service_response = service.update_sentiment_model(
      model_id: "model_id",
      language: "en",
      training_data: training_data
    )
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:delete, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/sentiment/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_sentiment_model(
      model_id: "model_id"
    )
    assert_equal({ "resulting_key" => true }, service_response.result)
  end

  def test_categories_models
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )

    stub_request(:post, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/categories?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    service_response = service.create_categories_model(
      language: "en",
      training_data: training_data
    )
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:get, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/categories?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_categories_models
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:get, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/categories/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_categories_model(model_id: "model_id")
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:put, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/categories/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    service_response = service.update_categories_model(
      model_id: "model_id",
      language: "en",
      training_data: training_data
    )
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:delete, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/categories/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_categories_model(
      model_id: "model_id"
    )
    assert_equal({ "resulting_key" => true }, service_response.result)
  end

  def test_classifications_models
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      authenticator: authenticator
    )

    stub_request(:post, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/classifications?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    service_response = service.create_classifications_model(
      language: "en",
      training_data: training_data
    )
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:get, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/classifications?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_classifications_models
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:get, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/classifications/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_classifications_model(model_id: "model_id")
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:put, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/classifications/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    service_response = service.update_classifications_model(
      model_id: "model_id",
      language: "en",
      training_data: training_data
    )
    assert_equal({ "resulting_key" => true }, service_response.result)

    stub_request(:delete, "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/v1/models/classifications/model_id?version=2018-03-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.natural-language-understanding.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { resulting_key: true }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_classifications_model(
      model_id: "model_id"
    )
    assert_equal({ "resulting_key" => true }, service_response.result)
  end
end
