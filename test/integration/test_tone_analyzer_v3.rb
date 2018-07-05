# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")

# Integration tests for the Tone Analyzer V3 Service
class ToneAnalyzerV3Test < Minitest::Test
  Minitest::Test.parallelize_me!
  def test_tone
    tone_text = File.read(Dir.getwd + "/resources/personality.txt")
    service = WatsonAPIs::ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: ENV["TONE_ANALYZER_USERNAME"],
      password: ENV["TONE_ANALYZER_PASSWORD"]
    )
    service.add_default_headers(
      headers: {
        "X-Watson-Learning-Opt-Out" => "1",
        "X-Watson-Test" => "1"
      }
    )
    service_response = service.tone(
      tone_input: tone_text,
      content_type: "text/plain"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_tone_with_args
    tone_text = File.read(Dir.getwd + "/resources/personality.txt")
    service = WatsonAPIs::ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: ENV["TONE_ANALYZER_USERNAME"],
      password: ENV["TONE_ANALYZER_PASSWORD"]
    )
    service.add_default_headers(
      headers: {
        "X-Watson-Learning-Opt-Out" => "1",
        "X-Watson-Test" => "1"
      }
    )
    service_response = service.tone(
      tone_input: tone_text,
      content_type: "text/plain",
      sentences: false
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_tone_chat
    service = WatsonAPIs::ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: ENV["TONE_ANALYZER_USERNAME"],
      password: ENV["TONE_ANALYZER_PASSWORD"]
    )
    service.add_default_headers(
      headers: {
        "X-Watson-Learning-Opt-Out" => "1",
        "X-Watson-Test" => "1"
      }
    )
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
