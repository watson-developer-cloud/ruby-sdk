# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("minitest/hooks/test")

# Integration tests for the Speech to Text V1 Service
class SpeechToTextV1Test < Minitest::Test
  include Minitest::Hooks
  Minitest::Test.parallelize_me!
  attr_accessor :service
  def before_all
    @service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: ENV["SPEECH_TO_TEXT_USERNAME"],
      password: ENV["SPEECH_TO_TEXT_PASSWORD"]
    )
    @service.add_default_headers(
      headers: {
        "X-Watson-Learning-Opt-Out" => "1",
        "X-Watson-Test" => "1"
      }
    )
  end

  def test_models
    output = JSON.parse(@service.list_models.body)
    refute(output.nil?)

    model = @service.get_model(
      model_id: "ko-KR_BroadbandModel"
    ).body
    model = JSON.parse(model)
    refute(model.nil?)

    begin
      @service.get_model(
        model_id: "bogus"
      )
    rescue StandardError => e
      refute(e.global_transaction_id.nil?)
    end
  end

  def test_recognize
    audio_file = File.open(Dir.getwd + "/resources/speech.wav")
    output = @service.recognize(
      audio: audio_file,
      content_type: "audio/l16; rate=44100"
    ).body
    assert_equal("thunderstorms could produce large hail isolated tornadoes and heavy rain ", output["results"][0]["alternatives"][0]["transcript"])
  end

  def test_recognitions
    output = @service.check_jobs.body
    refute(output.nil?)
  end

  def test_custom_corpora
    model = @service.create_language_model(
      name: "integration_test_model",
      base_model_name: "en-US_BroadbandModel"
    ).body
    customization_id = model["customization_id"]

    output = @service.list_corpora(
      customization_id: customization_id
    ).body
    refute(output.nil?)

    @service.delete_language_model(
      customization_id: customization_id
    )
  end

  def test_acoustic_model
    list_models = @service.list_acoustic_models.body
    refute(list_models.nil?)

    create_acoustic_model = @service.create_acoustic_model(
      name: "integration_test_model_ruby",
      base_model_name: "en-US_BroadbandModel"
    ).body
    refute(create_acoustic_model.nil?)

    get_acoustic_model = @service.get_acoustic_model(
      customization_id: create_acoustic_model["customization_id"]
    ).body
    refute(get_acoustic_model.nil?)

    @service.reset_acoustic_model(
      customization_id: get_acoustic_model["customization_id"]
    )

    @service.delete_acoustic_model(
      customization_id: get_acoustic_model["customization_id"]
    )
  end
end
