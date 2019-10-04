# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")

if !ENV["PERSONALITY_INSIGHTS_APIKEY"].nil? && !ENV["PERSONALITY_INSIGHTS_URL"].nil?
  # Integration tests for the Personality Insights V3 Service
  class PersonalityInsightsV3Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["PERSONALITY_INSIGHTS_APIKEY"]
      )
      @service = IBMWatson::PersonalityInsightsV3.new(
        version: "2017-10-13",
        url: ENV["PERSONALITY_INSIGHTS_URL"],
        authenticator: authenticator
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_plain_to_json
      personality_text = File.read(Dir.getwd + "/resources/personality-v3.txt")
      service_response = service.profile(
        accept: "application/json",
        content: personality_text,
        content_type: "text/plain;charset=utf-8"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_json_to_json
      personality_text = File.read(Dir.getwd + "/resources/personality-v3.json")
      service_response = service.profile(
        accept: "application/json",
        content: personality_text,
        content_type: "application/json",
        raw_scores: true,
        consumption_preferences: true
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_json_to_csv
      personality_text = File.read(Dir.getwd + "/resources/personality-v3.json")
      service_response = service.profile(
        content: personality_text,
        content_type: "application/json",
        accept: "text/csv",
        csv_headers: true,
        raw_scores: true,
        consumption_preferences: true
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_plain_to_json_es
      personality_text = File.read(Dir.getwd + "/resources/personality-v3-es.txt")
      service_response = service.profile(
        accept: "application/json",
        content: personality_text,
        content_type: "text/plain;charset=utf-8",
        content_language: "es",
        accept_language: "es"
      )
      assert((200..299).cover?(service_response.status))
    end
  end
else
  class PersonalityInsightsV3Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip personality insights integration tests because credentials have not been provided"
    end
  end
end
