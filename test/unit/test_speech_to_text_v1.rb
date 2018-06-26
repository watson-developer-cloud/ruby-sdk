# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Speech to Text V1 Service
class SpeechToTextV1Test < Minitest::Test
  def test_success
    models_response = {
      "models" => [
        {
          "url" => "https://stream.watsonplatform.net/speech-to-text/api/v1/models/WatsonModel",
          "rate" => 16_000,
          "name" => "WatsonModel",
          "language" => "en-US",
          "description" => "Watson model \"v7w_134k.3\" for Attila 2-5 reco engine."
        }
      ]
    }
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/models")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: models_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_models
    assert_equal(models_response, service_response.body)

    recognize_response = {
      "results" => [
        {
          "alternatives" => [
            {
              "transcript" => "thunderstorms could produce large hail isolated tornadoes and heavy rain"
            }
          ],
          "final" => true
        }
      ],
      "result_index" => 0
    }
    audio_file = File.open(Dir.getwd + "/resources/speech.wav")
    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "audio/l16; rate=44100",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: recognize_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.recognize(
      audio: audio_file,
      content_type: "audio/l16; rate=44100"
    )
    assert_equal(recognize_response, service_response.body)
  end

  def test_get_model
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/models/modelid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_model(
      model_id: "modelid"
    )
    assert_equal({ "bogus_response" => "yep" }, service_response.body)
  end

  def test_recognitions
    get_response = {
      "recognitions" => [
        {
          "created" => "2018-02-01T17:43:15.432Z",
          "id" => "6193190c-0777-11e8-9b4b-43ad845196dd",
          "updated" => "2018-02-01T17:43:17.998Z",
          "status" => "failed"
        }
      ]
    }
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/recognitions")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: get_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.check_jobs
    assert_equal("6193190c-0777-11e8-9b4b-43ad845196dd", service_response.body["recognitions"][0]["id"])

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/recognitions/jobid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "status" => "waiting" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.check_job(
      id: "jobid"
    )
    assert_equal({ "status" => "waiting" }, service_response.body)

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/recognitions")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "audio/basic",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "status" => "waiting" }.to_json, headers: { "Content-Type" => "application/json" })
    audio_file = File.open(Dir.getwd + "/resources/speech.wav")
    service_response = service.create_job(
      audio: audio_file,
      content_type: "audio/basic"
    )
    assert_equal({ "status" => "waiting" }, service_response.body)

    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/recognitions/jobid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "description" => "deleted successfully" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_job(
      id: "jobid"
    )
    assert_nil(service_response)
  end

  def test_callbacks
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/register_callback?callback_url=monitorcalls.com")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "status" => "created", "url" => "monitorcalls.com" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.register_callback(
      callback_url: "monitorcalls.com"
    )
    assert_equal({ "status" => "created", "url" => "monitorcalls.com" }, service_response.body)

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/unregister_callback?callback_url=monitorcalls.com")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "response" => "The callback URL was successfully unregistered" }.to_json, headers: { "Content-Type" => "applicaton/json" })
    service_response = service.unregister_callback(
      callback_url: "monitorcalls.com"
    )
    assert_nil(service_response)
  end

  def test_custom_model
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_language_models
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations")
      .with(
        body: "{\"name\":\"Example model\",\"base_model_name\":\"en-US_BroadbandModel\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_language_model(
      name: "Example model",
      base_model_name: "en-US_BroadbandModel"
    )
    assert_equal({ "bogus_response" => "yep" }, service_response.body)

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/customid/train")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.train_language_model(
      customization_id: "customid"
    )
    assert_nil(service_response)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/modelid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_language_model(
      customization_id: "modelid"
    )
    assert_equal({ "bogus_response" => "yep" }, service_response.body)

    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/modelid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_language_model(
      customization_id: "modelid"
    )
    assert_nil(service_response)
  end

  def test_acoustic_model
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_acoustic_models
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations")
      .with(
        body: "{\"name\":\"Example model\",\"base_model_name\":\"en-US_BroadbandModel\",\"description\":\"Example custom language model\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_acoustic_model(
      name: "Example model",
      base_model_name: "en-US_BroadbandModel",
      description: "Example custom language model"
    )
    assert_equal({ "bogus_response" => "yep" }, service_response.body)

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations/customid/train")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.train_acoustic_model(
      customization_id: "customid"
    )
    assert_nil(service_response)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations/modelid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_acoustic_model(
      customization_id: "modelid"
    )
    assert_equal({ "bogus_response" => "yep" }, service_response.body)

    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations/modelid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "bogus_response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_acoustic_model(
      customization_id: "modelid"
    )
    assert_nil(service_response)
  end

  def test_custom_corpora
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/customid/corpora")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_corpora(
      customization_id: "customid"
    )
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/customid/corpora/corpus")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    corpus_file = File.open(Dir.getwd + "/resources/speech_to_text/corpus-short-1.txt")
    service_response = service.add_corpus(
      customization_id: "customid",
      corpus_name: "corpus",
      corpus_file: corpus_file
    )
    assert_nil(service_response)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/customid/corpora/corpus")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_corpus(
      customization_id: "customid",
      corpus_name: "corpus"
    )
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/customid/corpora/corpus")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_corpus(
      customization_id: "customid",
      corpus_name: "corpus"
    )
    assert_nil(service_response)
  end

  def test_custom_words
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:put, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words/IEEE")
      .with(
        body: "{\"sounds_like\":[\"i triple e\"],\"display_as\":\"IEEE\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_word(
      customization_id: "custid",
      word_name: "IEEE",
      sounds_like: ["i triple e"],
      display_as: "IEEE"
    )
    assert_nil(service_response)

    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words/wordname")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_word(
      customization_id: "custid",
      word_name: "wordname"
    )
    assert_nil(service_response)

    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words/IEEE")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_word(
      customization_id: "custid",
      word_name: "IEEE"
    )
    assert_nil(service_response)

    custom_word = {
      word: "IEEE",
      sounds_like: [" i triple e"],
      display_as: "IEEE"
    }
    custom_words = [custom_word, custom_word, custom_word]

    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words")
      .with(
        body: "{\"words\":[{\"word\":\"IEEE\",\"sounds_like\":[\" i triple e\"],\"display_as\":\"IEEE\"},{\"word\":\"IEEE\",\"sounds_like\":[\" i triple e\"],\"display_as\":\"IEEE\"},{\"word\":\"IEEE\",\"sounds_like\":[\" i triple e\"],\"display_as\":\"IEEE\"}]}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_words(
      customization_id: "custid",
      words: custom_words
    )
    assert_nil(service_response)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words/IEEE")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_word(
      customization_id: "custid",
      word_name: "IEEE"
    )
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words/wordname")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_word(
      customization_id: "custid",
      word_name: "wordname"
    )
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_words(
      customization_id: "custid"
    )
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words?sort=alphabetical")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_words(
      customization_id: "custid",
      sort: "alphabetical"
    )
    assert_equal({ "get response" => "yep" }, service_response.body)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/customizations/custid/words?word_type=all")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "yep" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_words(
      customization_id: "custid",
      word_type: "all"
    )
    assert_equal({ "get response" => "yep" }, service_response.body)
  end

  def test_custom_audio_resources
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    audio_file = File.open(Dir.getwd + "/resources/speech.wav")
    stub_request(:post, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations/custid/audio/hiee")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "post response" => "done" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_audio(
      customization_id: "custid",
      audio_name: "hiee",
      audio_resource: audio_file,
      content_type: "application/json"
    )
    assert_nil(service_response)

    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations/custid/audio/hiee")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "post response" => "done" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_audio(
      customization_id: "custid",
      audio_name: "hiee"
    )
    assert_nil(service_response)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations/custid/audio/hiee")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response" => "done" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_audio(
      customization_id: "custid",
      audio_name: "hiee"
    )
    assert_equal({ "get response" => "done" }, service_response.body)

    stub_request(:get, "https://stream.watsonplatform.net/speech-to-text/api/v1/acoustic_customizations/custid/audio")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "get response all" => "done" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_audio(
      customization_id: "custid"
    )
    assert_equal({ "get response all" => "done" }, service_response.body)
  end

  def test_delete_user_data
    service = WatsonDeveloperCloud::SpeechToTextV1.new(
      username: "username",
      password: "password"
    )
    stub_request(:delete, "https://stream.watsonplatform.net/speech-to-text/api/v1/user_data?customer_id=id")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "stream.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "description" => "success" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_user_data(
      customer_id: "id"
    )
    assert_nil(service_response)
  end
end
