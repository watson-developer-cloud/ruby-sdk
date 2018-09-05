# frozen_string_literal: true

require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["TEXT_TO_SPEECH_USERNAME"].nil? && !ENV["TEXT_TO_SPEECH_PASSWORD"].nil?
  # Integration tests for the Text to Speech V1 Service
  class TextToSpeechV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      @service = IBMWatson::TextToSpeechV1.new(
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
      output = @service.list_voices.result
      refute(output["voices"].nil?)
      voice = @service.get_voice(voice: output["voices"][0]["name"])
      refute(voice.nil?)
    end

    def test_speak
      output = @service.synthesize(
        text: "my voice is my passport",
        accept: "audio/wav",
        voice: "en-US_AllisonVoice"
      ).result
      refute(output.nil?)
    end

    def test_pronunciation
      output = @service.get_pronunciation(
        text: "hello"
      ).result
      refute(output["pronunciation"].nil?)
    end

    def test_customizations
      service_response = @service.list_voice_models
      refute(service_response.nil?)
    end

    def test_custom_words
      skip "Skip to allow for concurrent travis jobs"
      customization_id = @service.create_voice_model(
        name: "test_integration_customization",
        description: "customization for tests"
      ).result["customization_id"]
      words = @service.list_words(customization_id: customization_id).result["words"]
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
      ).result
      assert(word["translation"] == "mackles")
      @service.delete_voice_model(
        customization_id: customization_id
      )
    end
  end
else
  class TextToSpeechV1Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip text to speech integration tests because credentials have not been provided"
    end
  end
end
