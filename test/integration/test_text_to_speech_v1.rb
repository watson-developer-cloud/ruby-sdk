# frozen_string_literal: true

require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["TEXT_TO_SPEECH_APIKEY"].nil? && !ENV["TEXT_TO_SPEECH_URL"].nil?
  # Integration tests for the Text to Speech V1 Service
  class TextToSpeechV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["TEXT_TO_SPEECH_APIKEY"]
      )
      @service = IBMWatson::TextToSpeechV1.new(
        url: ENV["TEXT_TO_SPEECH_URL"],
        authenticator: authenticator
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
      service_response = @service.list_custom_models
      refute(service_response.nil?)
    end

    def test_custom_words
      skip "Skip to allow for concurrent travis jobs"
      customization_id = @service.create_custom_model(
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
      @service.delete_custom_model(
        customization_id: customization_id
      )
    end

    def test_custom_prompts
      customization_id = @service.create_custom_model(
        name: "test_integration_customization",
        description: "RUBY customization for tests"
      ).result["customization_id"]

      prompt_metadata = { prompt_text: "Thank you and goodbye" }
      prompt_json = JSON[prompt_metadata]
      audio_file = File.open(Dir.getwd + "/resources/speech.wav")
      prompt = @service.add_custom_prompt(
        customization_id: customization_id,
        prompt_id: "rubyprompt_id",
        metadata: prompt_json,
        file: audio_file
      ).result["prompt"]
      assert(prompt == "Thank you and goodbye")

      prompts = @service.list_custom_prompts(customization_id: customization_id).result["prompts"]
      refute(prompts.nil?)

      prompt = @service.get_custom_prompt(
        customization_id: customization_id,
        prompt_id: "rubyprompt_id"
      ).result["prompt"]
      assert(prompt == "Thank you and goodbye")

      @service.delete_custom_prompt(
        customization_id: customization_id,
        prompt_id: "rubyprompt_id"
      )

      @service.delete_custom_model(
        customization_id: customization_id
      )
    end

    def test_speaker_models
      audio_file = File.open(Dir.getwd + "/resources/speech.wav")
      @service.create_speaker_model(
        speaker_name: "RubyMike",
        audio: audio_file
      ).result["speaker_model"]

      speakers = @service.list_speaker_models.result["speakers"]
      speaker_id = speakers[0]["speaker_id"]
      # puts JSON.pretty_generate(speakers)

      @service.get_speaker_model(
        speaker_id: speaker_id
      ).result["models_speaker"]

      # speaker_id = d3d03b69-4035-4420-928d-7ac2e0249829
      @service.delete_speaker_model(
        speaker_id: speaker_id
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
