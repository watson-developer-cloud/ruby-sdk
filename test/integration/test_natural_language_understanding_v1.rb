# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")

unless ENV["NATURAL_LANGUAGE_UNDERSTANDING_USERNAME"].nil? || ENV["NATURAL_LANGUAGE_UNDERSTANDING_PASSWORD"].nil?
  # Integration tests for the Natural Language Understanding V1 Service
  class NaturalLanguageUnderstandingV1Test < Minitest::Test
    def test_text_analyze
      service = IBMWatson::NaturalLanguageUnderstandingV1.new(
        version: "2018-03-16",
        username: ENV["NATURAL_LANGUAGE_UNDERSTANDING_USERNAME"],
        password: ENV["NATURAL_LANGUAGE_UNDERSTANDING_PASSWORD"]
      )
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
      service = IBMWatson::NaturalLanguageUnderstandingV1.new(
        version: "2018-03-16",
        username: ENV["NATURAL_LANGUAGE_UNDERSTANDING_USERNAME"],
        password: ENV["NATURAL_LANGUAGE_UNDERSTANDING_PASSWORD"]
      )
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
      service = IBMWatson::NaturalLanguageUnderstandingV1.new(
        version: "2018-03-16",
        username: ENV["NATURAL_LANGUAGE_UNDERSTANDING_USERNAME"],
        password: ENV["NATURAL_LANGUAGE_UNDERSTANDING_PASSWORD"]
      )
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
      service = IBMWatson::NaturalLanguageUnderstandingV1.new(
        version: "2018-03-16",
        username: ENV["NATURAL_LANGUAGE_UNDERSTANDING_USERNAME"],
        password: ENV["NATURAL_LANGUAGE_UNDERSTANDING_PASSWORD"]
      )
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
end
