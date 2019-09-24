# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Natural Language Classifier V1 Service
class NaturalLanguageClassifierV1Test < Minitest::Test
  def test_success
    authenticator = IBMWatson::Auth::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageClassifierV1.new(
      authenticator: authenticator
    )
    list_response = {
      "classifiers" => [
        {
          "url" => "https://gateway.watsonplatform.net/natural-language-classifier-experimental/api/v1/classifiers/497EF2-nlc-00",
          "classifier_id" => "497EF2-nlc-00"
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: list_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_classifiers
    assert_equal(list_response, service_response.result)

    status_response = {
      "url" => "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/497EF2-nlc-00",
      "status" => "Available",
      "status_description" => "The classifier instance is now available and is ready to take classifier requests.",
      "classifier_id" => "497EF2-nlc-00"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/497EF2-nlc-00")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: status_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_classifier(
      classifier_id: "497EF2-nlc-00"
    )
    assert_equal(status_response, service_response.result)

    classify_response = {
      "url" => "https://gateway.watsonplatform.net/natural-language-classifier/api/v1",
      "text" => "test",
      "classes" =>
      [
        {
          "class_name" => "conditions",
          "confidence" => 0.6575315710901418
        },
        {
          "class_name" => "temperature",
          "confidence" => 0.3424684289098582
        }
      ],
      "classifier_id" => "497EF2-nlc-00",
      "top_class" => "conditions"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/497EF2-nlc-00/classify")
      .with(
        body: "{\"text\":\"test\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: classify_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.classify(
      classifier_id: "497EF2-nlc-00",
      text: "test"
    )
    assert_equal(classify_response, service_response.result)

    create_response = {
      "url" => "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/497EF2-nlc-00",
      "status" => "Available",
      "status_description" => "The classifier instance is now available and is ready to take classifier requests.",
      "classifier_id" => "497EF2-nlc-00"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: create_response.to_json, headers: { "Content-Type" => "application/json" })
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    service_response = service.create_classifier(
      training_data: training_data,
      training_metadata: { "language" => "en" }
    )
    assert_equal(create_response, service_response.result)

    service_response = service.create_classifier(
      training_data: { "training" => "data" },
      training_metadata: { "language" => "en" }
    )
    assert_equal(create_response, service_response.result)

    stub_request(:delete, "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/497EF2-nlc-00")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_classifier(
      classifier_id: "497EF2-nlc-00"
    )
    assert_nil(service_response)
  end

  def test_classify_collection
    authenticator = IBMWatson::Auth::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::NaturalLanguageClassifierV1.new(
      authenticator: authenticator
    )
    classify_collection_response = {
      "classifier_id" => "497EF2-nlc-00",
      "url" => "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/10D41B-nlc-1",
      "collection" => [
        {
          "text" => "How hot will it be today?",
          "top_class" => "temperature",
          "classes" => [
            {
              "class_name" => "temperature",
              "confidence" => 0.9930558798985937
            },
            {
              "class_name" => "conditions",
              "confidence" => 0.006944120101406304
            }
          ]
        },
        {
          "text" => "Is it hot outside?",
          "top_class" => "temperature",
          "classes" => [
            {
              "class_name" => "temperature",
              "confidence" => 1
            },
            {
              "class_name" => "conditions",
              "confidence" => 0
            }
          ]
        }
      ]
    }
    classifier_id = "497EF2-nlc-00"
    collection = [{ "text" => "How hot will it be today?" }, { "text" => "Is it hot outside?" }]
    stub_request(:post, "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/497EF2-nlc-00/classify_collection")
      .with(
        body: "{\"collection\":[{\"text\":\"How hot will it be today?\"},{\"text\":\"Is it hot outside?\"}]}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: classify_collection_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.classify_collection(
      classifier_id: classifier_id,
      collection: collection
    )
    assert_equal(classify_collection_response, service_response.result)
  end
end
