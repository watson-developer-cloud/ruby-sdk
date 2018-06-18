# frozen_string_literal: true

require_relative("./../../lib/watson_developer_cloud.rb")
require("json")
require("minitest/autorun")
require("minitest/hooks/test")

# Integration tests for the Text to Speech V1 Service
class TextToSpeechV1Test < Minitest::Test
  include Minitest::Hooks
  Minitest::Test.parallelize_me!
  attr_accessor :service
  def before_all
    @service = WatsonDeveloperCloud::TextToSpeechV1.new(
      username: ENV["TEXT_TO_SPEECH_USERNAME"],
      password: ENV["TEXT_TO_SPEECH_PASSWORD"]
    )
    @service.add_default_headers(
      headers: {
        "X-Watson-Learning-Opt-Out" => "1",
        "X-Watson-Test" => "1"
      }
    )
  end

  def test_voices
    output = JSON.parse(@service.list_voices.body)
    refute(output["voices"].nil?)
    voice = @service.get_voice(voice: output["voices"][0]["name"])
    refute(voice.nil?)
  end

  def test_speak
    output = @service.synthesize(
      text: "my voice is my passport",
      accept: "audio/wav",
      voice: "en-US_AllisonVoice"
    ).body
    refute(output.nil?)
  end

  def test_pronunciation
    output = @service.get_pronunciation(
      text: "hello"
    ).body
    refute(output["pronunciation"].nil?)
  end

  def test_customizations
    service_response = @service.list_voice_models
    refute(service_response.nil?)
  end

  def test_custom_words
    customization_id = @service.create_voice_model(
      name: "test_integration_customization",
      description: "customization for tests"
    ).body["customization_id"]
    words = @service.list_words(customization_id: customization_id).body["words"]
    assert(words.length.zero?)
    @service.add_word(
      customization_id: customization_id,
      word: "ACLs",
      translation: "ackles"
    )
    words = [{ "word" => "MACLs", "translation" => "mackles" }]
    @service.add_words(
      customization_id: customization_id,
      words: words
    )
    @service.delete_word(
      customization_id: customization_id,
      word: "ACLs"
    )
    word = @service.get_word(
      customization_id: customization_id,
      word: "MACLs"
    ).body
    assert(word["translation"] == "mackles")
    @service.delete_voice_model(
      customization_id: customization_id
    )
  end
end