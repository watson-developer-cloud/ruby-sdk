# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")

if !ENV["TONE_ANALYZER_APIKEY"].nil? && !ENV["TONE_ANALYZER_URL"].nil?
  # Integration tests for the Tone Analyzer V3 Service
  class ToneAnalyzerV3Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["TONE_ANALYZER_APIKEY"]
      )
      @service = IBMWatson::ToneAnalyzerV3.new(
        url: ENV["TONE_ANALYZER_URL"],
        version: "2017-09-21",
        authenticator: authenticator
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_tone
      tone_text = File.read(Dir.getwd + "/resources/tone-example.json")
      service_response = service.tone(
        tone_input: tone_text,
        content_type: "application/json"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_tone_with_args
      tone_text = File.read(Dir.getwd + "/resources/tone-example.json")
      service_response = service.tone(
        tone_input: tone_text,
        content_type: "application/json",
        sentences: false
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_tone_chat
      utterances = [
        {
          "text" => "I am very happy",
          "user" => "glenn"
        }
      ]
      service_response = service.tone_chat(
        utterances: utterances
      )
      assert((200..299).cover?(service_response.status))
    end
  end
else
  class ToneAnalyzerV3Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip tone analyzer integration tests because credentials have not been provided"
    end
  end
end
