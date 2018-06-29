# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require_relative("./../../lib/watson_apis/websocket/recognize_abstract_callback.rb")
require_relative("./../../lib/watson_apis/websocket/speech_to_text_websocket_listener.rb")
require("minitest/hooks/test")
require("concurrent")

# Recognize Callback class
class MyRecognizeCallback < WatsonAPIs::RecognizeCallback
  def initialize(atomic_boolean: nil)
    super
    @atomic_boolean = atomic_boolean
  end

  def on_error(error:)
    puts "Error received: #{error}"
  end

  def on_inactivity_timeout(*)
    @atomic_boolean.make_true
  end
end

# Integration tests for the Speech to Text V1 Service
class SpeechToTextV1Test < Minitest::Test
  include Minitest::Hooks

  attr_accessor :service
  def before_all
    @service = WatsonAPIs::SpeechToTextV1.new(
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
    refute_nil(output)

    model = @service.get_model(
      model_id: "ko-KR_BroadbandModel"
    ).body
    model = JSON.parse(model)
    refute_nil(model)

    begin
      @service.get_model(
        model_id: "bogus"
      )
    rescue StandardError => e
      refute_nil(e.global_transaction_id)
    end
  end

  def test_recognize
    audio_file = File.open(Dir.getwd + "/resources/speech.wav")
    output = @service.recognize(
      audio: audio_file,
      content_type: "audio/l16; rate=44100"
    ).body
    refute_nil(output["results"][0]["alternatives"][0]["transcript"])
  end

  def test_recognitions
    output = @service.check_jobs.body
    refute_nil(output)
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
    refute_nil(output)

    @service.delete_language_model(
      customization_id: customization_id
    )
  end

  def test_acoustic_model
    list_models = @service.list_acoustic_models.body
    refute_nil(list_models)

    create_acoustic_model = @service.create_acoustic_model(
      name: "integration_test_model_ruby",
      base_model_name: "en-US_BroadbandModel"
    ).body
    refute_nil(create_acoustic_model)

    get_acoustic_model = @service.get_acoustic_model(
      customization_id: create_acoustic_model["customization_id"]
    ).body
    refute_nil(get_acoustic_model)

    @service.reset_acoustic_model(
      customization_id: get_acoustic_model["customization_id"]
    )

    @service.delete_acoustic_model(
      customization_id: get_acoustic_model["customization_id"]
    )
  end

  def test_recognize_websocket
    audio_file = File.open(Dir.getwd + "/resources/speech.wav")
    mycallback = MyRecognizeCallback.new
    speech = @service.recognize_with_websocket(
      audio: audio_file,
      recognize_callback: mycallback,
      interim_results: true,
      timestamps: true,
      max_alternatives: 2,
      word_alternatives_threshold: 0.5,
      model: "en-US_BroadbandModel"
    )
    thr = Thread.new { speech.start }
    thr.join
  end

  def test_inactivity_timeout_with_websocket
    audio_file = File.open(Dir.getwd + "/resources/sound-with-pause.wav")
    atomic_boolean = Concurrent::AtomicBoolean.new
    mycallback = MyRecognizeCallback.new(atomic_boolean: atomic_boolean)
    speech = @service.recognize_with_websocket(
      audio: audio_file,
      recognize_callback: mycallback,
      interim_results: true,
      inactivity_timeout: 3,
      timestamps: true,
      max_alternatives: 2,
      word_alternatives_threshold: 0.5,
      model: "en-US_BroadbandModel"
    )
    thr = Thread.new { speech.start }
    thr.join
    assert(atomic_boolean.true?)
  end
end
