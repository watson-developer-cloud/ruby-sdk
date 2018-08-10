# frozen_string_literal: true

require_relative("./../test_helper.rb")
require_relative("./../../lib/ibm_watson/websocket/recognize_callback.rb")
require_relative("./../../lib/ibm_watson/websocket/speech_to_text_websocket_listener.rb")
require("minitest/hooks/test")
require("concurrent")

# Recognize Callback class
class MyRecognizeCallback < IBMWatson::RecognizeCallback
  def initialize(atomic_boolean: nil)
    super
    @atomic_boolean = atomic_boolean
  end

  def on_error(*)
    @atomic_boolean.make_true
  end

  def on_inactivity_timeout(*)
    @atomic_boolean.make_true
  end
end

unless ENV["SPEECH_TO_TEXT_USERNAME"].nil? || ENV["SPEECH_TO_TEXT_PASSWORD"].nil?
  # Integration tests for the Speech to Text V1 Service
  class SpeechToTextV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      @service = IBMWatson::SpeechToTextV1.new(
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
      output = @service.list_models.result
      refute_nil(output)

      model = @service.get_model(
        model_id: "ko-KR_BroadbandModel"
      ).result
      model = model
      refute_nil(model)

      begin
        @service.get_model(
          model_id: "bogus"
        )
      rescue StandardError => e
        refute_nil(e.global_transaction_id)
      end
    end

    def test_recognize_await
      audio_file = File.open(Dir.getwd + "/resources/speech.wav")
      future = @service.await.recognize(
        audio: audio_file,
        content_type: "audio/l16; rate=44100"
      )
      output = future.value.result
      refute_nil(output["results"][0]["alternatives"][0]["transcript"])
    end

    def test_recognize_async
      audio_file = File.open(Dir.getwd + "/resources/speech.wav")
      future = @service.async.recognize(
        audio: audio_file,
        content_type: "audio/l16; rate=44100"
      )
      future.wait!
      output = future.value.result
      refute_nil(output["results"][0]["alternatives"][0]["transcript"])
    end

    def test_recognitions
      output = @service.check_jobs.result
      refute_nil(output)
    end

    def test_custom_corpora
      skip "Skip to allow for concurrent travis jobs"
      model = @service.create_language_model(
        name: "integration_test_model",
        base_model_name: "en-US_BroadbandModel"
      ).result
      customization_id = model["customization_id"]

      output = @service.list_corpora(
        customization_id: customization_id
      ).result
      refute_nil(output)

      @service.delete_language_model(
        customization_id: customization_id
      )
    end

    def test_acoustic_model
      list_models = @service.list_acoustic_models.result
      refute_nil(list_models)

      skip "Skip to allow for concurrent travis jobs"
      create_acoustic_model = @service.create_acoustic_model(
        name: "integration_test_model_ruby",
        base_model_name: "en-US_BroadbandModel"
      ).result
      refute_nil(create_acoustic_model)

      get_acoustic_model = @service.get_acoustic_model(
        customization_id: create_acoustic_model["customization_id"]
      ).result
      refute_nil(get_acoustic_model)

      @service.reset_acoustic_model(
        customization_id: get_acoustic_model["customization_id"]
      )

      @service.delete_acoustic_model(
        customization_id: get_acoustic_model["customization_id"]
      )
    end

    def test_recognize_websocket_as_chunks
      audio_file = File.open(Dir.getwd + "/resources/speech.wav")
      mycallback = MyRecognizeCallback.new
      speech = @service.recognize_using_websocket(
        chunk_data: true,
        recognize_callback: mycallback,
        interim_results: true,
        timestamps: true,
        max_alternatives: 2,
        word_alternatives_threshold: 0.5,
        content_type: "audio/wav"
      )
      Thread.new do
        until audio_file.eof?
          chunk = audio_file.read(1024)
          speech.add_audio_chunk(chunk: chunk)
        end
        sleep(1)
        speech.stop_audio # Tell the websocket object that no more audio will be added
      end
      thr = Thread.new { speech.start }
      thr.join
    end

    def test_recognize_websocket
      audio_file = File.open(Dir.getwd + "/resources/speech.wav")
      mycallback = MyRecognizeCallback.new
      speech = @service.recognize_using_websocket(
        audio: audio_file,
        recognize_callback: mycallback,
        interim_results: true,
        timestamps: true,
        max_alternatives: 2,
        word_alternatives_threshold: 0.5,
        content_type: "audio/wav"
      )
      thr = Thread.new { speech.start }
      thr.join
    end

    def test_inactivity_timeout_using_websocket
      audio_file = File.open(Dir.getwd + "/resources/sound-with-pause.wav")
      atomic_boolean = Concurrent::AtomicBoolean.new
      mycallback = MyRecognizeCallback.new(atomic_boolean: atomic_boolean)
      speech = @service.recognize_using_websocket(
        audio: audio_file,
        recognize_callback: mycallback,
        interim_results: true,
        inactivity_timeout: 3,
        timestamps: true,
        max_alternatives: 2,
        word_alternatives_threshold: 0.5,
        content_type: "audio/wav"
      )
      thr = Thread.new { speech.start }
      thr.join
      assert(atomic_boolean.true?)
    end

    def test_broken_audio_using_websocket
      audio_file = File.open(Dir.getwd + "/resources/car.jpg")
      atomic_boolean = Concurrent::AtomicBoolean.new
      mycallback = MyRecognizeCallback.new(atomic_boolean: atomic_boolean)
      speech = @service.recognize_using_websocket(
        audio: audio_file,
        recognize_callback: mycallback,
        interim_results: true,
        timestamps: true,
        max_alternatives: 2,
        word_alternatives_threshold: 0.5,
        content_type: "audio/wav"
      )
      thr = Thread.new { speech.start }
      thr.join
      assert(atomic_boolean.true?)
    end

    def test_invalid_auth_using_websocket
      audio_file = File.open(Dir.getwd + "/resources/speech.wav")
      atomic_boolean = Concurrent::AtomicBoolean.new
      mycallback = MyRecognizeCallback.new(atomic_boolean: atomic_boolean)
      temp_service = IBMWatson::SpeechToTextV1.new(
        iam_access_token: "bogus_iam_access_token"
      )
      temp_service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      speech = temp_service.recognize_using_websocket(
        audio: audio_file,
        recognize_callback: mycallback,
        interim_results: true,
        timestamps: true,
        max_alternatives: 2,
        word_alternatives_threshold: 0.5,
        content_type: "audio/wav"
      )
      thr = Thread.new { speech.start }
      thr.join
      assert(atomic_boolean.true?)
    end

    def test_add_word
      model = @service.create_language_model(
        name: "integration_test_model",
        base_model_name: "en-US_BroadbandModel"
      ).result
      customization_id = model["customization_id"]
      service_response = @service.add_word(
        customization_id: customization_id,
        word_name: "IEEE",
        sounds_like: ["i triple e"],
        display_as: "IEEE"
      )
      assert_nil(service_response)
      @service.delete_language_model(
        customization_id: customization_id
      )
    end
  end
end
