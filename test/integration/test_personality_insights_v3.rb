# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")

# Integration tests for the Personality Insights V3 Service
class PersonalityInsightsV3Test < Minitest::Test
  Minitest::Test.parallelize_me!
  def test_plain_to_json
    personality_text = File.read(Dir.getwd + "/resources/personality-v3.txt")
    service = WatsonDeveloperCloud::PersonalityInsightsV3.new(
      version: "2017-10-13",
      username: ENV["PERSONALITY_INSIGHTS_USERNAME"],
      password: ENV["PERSONALITY_INSIGHTS_PASSWORD"]
    )
    service_response = service.profile(
      content: personality_text,
      content_type: "text/plain;charset=utf-8"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_json_to_json
    personality_text = File.read(Dir.getwd + "/resources/personality-v3.json")
    service = WatsonDeveloperCloud::PersonalityInsightsV3.new(
      version: "2017-10-13",
      username: ENV["PERSONALITY_INSIGHTS_USERNAME"],
      password: ENV["PERSONALITY_INSIGHTS_PASSWORD"]
    )
    service_response = service.profile(
      content: personality_text,
      content_type: "application/json",
      raw_scores: true,
      consumption_preferences: true
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_json_to_csv
    personality_text = File.read(Dir.getwd + "/resources/personality-v3.json")
    service = WatsonDeveloperCloud::PersonalityInsightsV3.new(
      version: "2017-10-13",
      username: ENV["PERSONALITY_INSIGHTS_USERNAME"],
      password: ENV["PERSONALITY_INSIGHTS_PASSWORD"]
    )
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
    service = WatsonDeveloperCloud::PersonalityInsightsV3.new(
      version: "2017-10-13",
      username: ENV["PERSONALITY_INSIGHTS_USERNAME"],
      password: ENV["PERSONALITY_INSIGHTS_PASSWORD"]
    )
    service_response = service.profile(
      content: personality_text,
      content_type: "text/plain;charset=utf-8",
      content_language: "es",
      accept_language: "es"
    )
    assert((200..299).cover?(service_response.status))
  end
end
