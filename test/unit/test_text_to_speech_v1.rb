# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Text to Speech V1 Service
class TextToSpeechV1Test < Minitest::Test
  def test_success
    voices_response = {
      "voices" => [
        {
          "url" => "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/voices/VoiceEnUsLisa",
          "gender" => "female",
          "name" => "VoiceEnUsLisa",
          "language" => "en-US"
        }, {
          "url" => "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/voices/VoiceEsEsEnrique",
          "gender" => "male",
          "name" => "VoiceEsEsEnrique",
          "language" => "es-ES"
        }, {
          "url" => "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/voices/VoiceEnUsMichael",
          "gender" => "male",
          "name" => "VoiceEnUsMichael",
          "language" => "en-US"
        }, {
          "url" => "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/voices/VoiceEnUsAllison",
          "gender" => "female",
          "name" => "VoiceEnUsAllison",
          "language" => "en-US"
        }
      ]
    }
    voice_response = {
      "url" => "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/voices/en-US_AllisonVoice",
      "name" => "en-US_AllisonVoice",
      "language" => "en-US",
      "customizable" => true,
      "gender" => "female",
      "description" => "Allison: American English female voice.",
      "supported_features" => {
        "custom_pronunciation" => true,
        "voice_transformation" => true
      }
    }
    synthesize_response_body = "<binary response>"
    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/voices")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: voices_response.to_json, headers: { "Content-Type" => "application/json" })
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::TextToSpeechV1.new(
      username: "username",
      password: "password",
      authenticator: authenticator
    )
    service_response = service.list_voices
    assert_equal(voices_response, service_response.result)

    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/voices/en-us_AllisonVoice")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: voice_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_voice(
      voice: "en-us_AllisonVoice"
    )
    assert_equal(voice_response, service_response.result)

    stub_request(:post, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/synthesize")
      .with(
        body: "{\"text\":\"hello\"}",
        headers: {
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: synthesize_response_body, headers: {})
    service_response = service.synthesize(
      text: "hello"
    )
    assert_equal(synthesize_response_body, service_response.result)
  end

  def test_get_pronunciation
    response = {
      "pronunciation" => "pronunciation info"
    }
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::TextToSpeechV1.new(
      username: "username",
      password: "password",
      authenticator: authenticator
    )
    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/pronunciation?text=this%20is%20some%20text")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_pronunciation(
      text: "this is some text"
    )
    assert_equal(response, service_response.result)

    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/pronunciation?text=yo&voice=VoiceEnUsLisa")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_pronunciation(
      text: "yo",
      voice: "VoiceEnUsLisa"
    )
    assert_equal(response, service_response.result)

    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/pronunciation?format=ipa&text=yo&voice=VoiceEnUsLisa")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_pronunciation(
      text: "yo",
      voice: "VoiceEnUsLisa",
      format: "ipa"
    )
    assert_equal(response, service_response.result)
  end

  def test_custom_voice_models
    response = { "customizations" => "yep" }
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::TextToSpeechV1.new(
      username: "username",
      password: "password",
      authenticator: authenticator
    )
    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_voice_models
    assert_equal(response, service_response.result)

    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations?language=en-US")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_voice_models(
      language: "en-US"
    )
    assert_equal(response, service_response.result)

    stub_request(:post, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations")
      .with(
        body: "{\"name\":\"name\",\"description\":\"description\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_voice_model(
      name: "name",
      description: "description"
    )
    assert_equal(response, service_response.result)

    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { "customization" => "yep, just one" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_voice_model(
      customization_id: "custid"
    )
    assert_equal({ "customization" => "yep, just one" }, service_response.result)

    stub_request(:post, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid")
      .with(
        body: "{\"name\":\"name\",\"description\":\"description\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.update_voice_model(
      customization_id: "custid",
      name: "name",
      description: "description"
    )
    assert(service_response.nil?)

    stub_request(:delete, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid")
      .with(
        headers: {
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_voice_model(
      customization_id: "custid"
    )
    assert(service_response.nil?)
  end

  def test_custom_words
    response = { "customizations" => "yep" }
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::TextToSpeechV1.new(
      username: "username",
      password: "password",
      authenticator: authenticator
    )
    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid/words")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_words(
      customization_id: "custid"
    )
    assert_equal(response, service_response.result)

    stub_request(:post, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid/words")
      .with(
        body: "{\"words\":[{\"word\":\"one\",\"translation\":\"one\"},{\"word\":\"two\",\"translation\":\"two\"}]}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: "", headers: { "Content-Type" => "application/json" })
    service_response = service.add_words(
      customization_id: "custid",
      words: [
        { "word" => "one", "translation" => "one" },
        { "word" => "two", "translation" => "two" }
      ]
    )
    assert(service_response.nil?)

    stub_request(:get, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid/words/word")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: { "customization" => "yep, just one" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_word(
      customization_id: "custid",
      word: "word"
    )
    assert_equal({ "customization" => "yep, just one" }, service_response.result)

    stub_request(:put, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid/words/word")
      .with(
        body: "{\"translation\":\"I'm translated\"}",
        headers: {
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: "", headers: { "Content-Type" => "application/json" })
    service_response = service.add_word(
      customization_id: "custid",
      word: "word",
      translation: "I'm translated"
    )
    assert(service_response.nil?)

    stub_request(:delete, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/customizations/custid/words/word")
      .with(
        headers: {
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: "", headers: { "Content-Type" => "application/json" })
    service_response = service.delete_word(
      customization_id: "custid",
      word: "word"
    )
    assert(service_response.nil?)
  end

  def test_delete_user_data
    authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
      username: "username",
      password: "password"
    )
    service = IBMWatson::TextToSpeechV1.new(
      username: "username",
      password: "password",
      authenticator: authenticator
    )
    stub_request(:delete, "https://api.us-south.text-to-speech.watson.cloud.ibm.com/v1/user_data?customer_id=id")
      .with(
        headers: {
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "api.us-south.text-to-speech.watson.cloud.ibm.com"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_user_data(
      customer_id: "id"
    )
    assert(service_response.nil?)
  end
end
