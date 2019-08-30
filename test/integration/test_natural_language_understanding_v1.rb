# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")

if !ENV["NATURAL_LANGUAGE_UNDERSTANDING_APIKEY"].nil? && !ENV["NATURAL_LANGUAGE_UNDERSTANDING_URL"].nil?
  # Integration tests for the Natural Language Understanding V1 Service
  class NaturalLanguageUnderstandingV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      authenticator = IBMCloudSdkCore::IamAuthenticator.new(
        apikey: ENV["NATURAL_LANGUAGE_UNDERSTANDING_APIKEY"]
      )
      @service = IBMWatson::NaturalLanguageUnderstandingV1.new(
        version: "2018-03-16",
        authenticator: authenticator,
        url: ENV["NATURAL_LANGUAGE_UNDERSTANDING_URL"]
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_text_analyze
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      text = "IBM is an American multinational technology company "
      text += "headquartered in Armonk, New York, United States, "
      text += "with operations in over 170 countries."
      service_response = service.analyze(
        features: {
          entities: {
            emotion: true,
            sentiment: true,
            limit: 2
          },
          keywords: {
            emotion: true,
            sentiment: true,
            limit: 2
          }
        },
        text: text
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_html_analyze
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.analyze(
        features: {
          sentiment: {}
        },
        html: "<span>hello this is a test </span>"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_url_analyze
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.analyze(
        features: {
          categories: {}
        },
        url: "www.ibm.com"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_models
      skip
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.list_models
      assert((200..299).cover?(service_response.status))
    end
  end
else
  class NaturalLanguageUnderstandingV1Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip natural language understanding integration tests because credentials have not been provided"
    end
  end
end
