# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Language Translator V3 Service
class LanguageTranslatorV3Test < Minitest::Test
  def test_translate_source_target
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "character_count" => 19,
      "translations" => [{ "translation" => "Hello, how are you ? \u20ac" }],
      "word_count" => 4
    }
    stub_request(:post, "https://gateway.watsonplatform.net/language-translator/api/v3/translate?version=2018-05-01")
      .with(
        body: "{\"text\":\"Hola, cómo estás? €\",\"source\":\"es\",\"target\":\"en\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.translate(
      text: "Hola, cómo estás? €",
      source: "es",
      target: "en"
    )
    assert_equal(expected, service_response.body)
  end

  def test_translate_model_id
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "character_count" => 22,
      "translations" => [
        {
          "translation" => "Messi es el mejor"
        }
      ],
      "word_count" => 5
    }
    stub_request(:post, "https://gateway.watsonplatform.net/language-translator/api/v3/translate?version=2018-05-01")
      .with(
        body: "{\"text\":\"Messi is the best ever\",\"model_id\":\"en-es-conversational\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.translate(
      text: "Messi is the best ever",
      model_id: "en-es-conversational"
    )
    assert_equal(expected, service_response.body)
  end

  def test_identify
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "languages" => [
        {
          "confidence" => 0.477673,
          "language" => "zh"
        },
        {
          "confidence" => 0.262053,
          "language" => "zh-TW"
        },
        {
          "confidence" => 0.00958378,
          "language" => "en"
        }
      ]
    }
    stub_request(:post, "https://gateway.watsonplatform.net/language-translator/api/v3/identify?version=2018-05-01")
      .with(
        body: "祝你有美好的一天",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Content-Type" => "text/plain",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.identify(
      text: "祝你有美好的一天"
    )
    assert_equal(expected, service_response.body)
  end

  def test_list_identifiable_languages
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "languages" => [
        {
          "name" => "German",
          "language" => "de"
        },
        {
          "name" => "Greek",
          "language" => "el"
        },
        {
          "name" => "English",
          "language" => "en"
        },
        {
          "name" => "Esperanto",
          "language" => "eo"
        },
        {
          "name" => "Spanish",
          "language" => "es"
        },
        {
          "name" => "Chinese",
          "language" => "zh"
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/language-translator/api/v3/identifiable_languages?version=2018-05-01")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_identifiable_languages
    assert_equal(expected, service_response.body)
  end

  def test_create_model
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "status" => "available",
      "model_id" => "en-es-conversational",
      "domain" => "conversational",
      "target" => "es",
      "customizable" => false,
      "source" => "en",
      "base_model_id" => "en-es-conversational",
      "owner" => "",
      "default_model" => false,
      "name" => "test_glossary"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/language-translator/api/v3/models?base_model_id=en-fr&name=test_glossary&version=2018-05-01")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    custom_model = File.open(Dir.getwd + "/resources/language_translator_model.tmx")
    service_response = service.create_model(
      base_model_id: "en-fr",
      name: "test_glossary",
      forced_glossary: custom_model
    )
    assert_equal(expected, service_response.body)

    service_response = service.create_model(
      base_model_id: "en-fr",
      name: "test_glossary",
      forced_glossary: custom_model.read,
      parallel_corpus: "parallel corpus",
      parallel_corpus_filename: "parallel_corpus_filename"
    )
    assert_equal(expected, service_response.body)

    service_response = service.create_model(
      base_model_id: "en-fr",
      name: "test_glossary",
      forced_glossary: custom_model,
      forced_glossary_filename: "language_translator_model.tmx",
      parallel_corpus: "parallel corpus"
    )
    assert_equal(expected, service_response.body)
  end

  def test_delete_model
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "status" => "OK"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/language-translator/api/v3/models/en-es-conversational?version=2018-05-01")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_model(
      model_id: "en-es-conversational"
    )
    assert_equal(expected, service_response.body)
  end

  def test_get_model
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "status" => "available",
      "model_id" => "en-es-conversational",
      "domain" => "conversational",
      "target" => "es",
      "customizable" => false,
      "source" => "en",
      "base_model_id" => "",
      "owner" => "",
      "default_model" => false,
      "name" => "en-es-conversational"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/language-translator/api/v3/models/en-es-conversational?version=2018-05-01")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_model(
      model_id: "en-es-conversational"
    )
    assert_equal(expected, service_response.body)
  end

  def test_list_models
    stub_request(:post, "https://iam.bluemix.net/identity/token")
      .with(
        body: { "apikey" => "iam_api_key", "grant_type" => "urn:ibm:params:oauth:grant-type:apikey", "response_type" => "cloud_iam" },
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic Yng6Yng=",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "iam.bluemix.net"
        }
      ).to_return(
        status: 200,
        body: {
          "access_token" => "oAeisG8yqPY7sFR_x66Z15",
          "token_type" => "Bearer",
          "expires_in" => 3600,
          "expiration" => 1_524_167_011,
          "refresh_token" => "jy4gl91BQ"
        }.to_json,
        headers: {}
      )
    service = WatsonAPIs::LanguageTranslatorV3.new(
      version: "2018-05-01",
      iam_api_key: "iam_api_key"
    )
    expected = {
      "models" => [
        {
          "status" => "available",
          "model_id" => "en-es-conversational",
          "domain" => "conversational",
          "target" => "es",
          "customizable" => false,
          "source" => "en",
          "base_model_id" => "",
          "owner" => "",
          "default_model" => false,
          "name" => "en-es-conversational"
        },
        {
          "status" => "available",
          "model_id" => "es-en",
          "domain" => "news",
          "target" => "en",
          "customizable" => true,
          "source" => "es",
          "base_model_id" => "",
          "owner" => "",
          "default_model" => true,
          "name" => "es-en"
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/language-translator/api/v3/models?version=2018-05-01")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer oAeisG8yqPY7sFR_x66Z15",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: expected.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_models
    assert_equal(expected, service_response.body)
  end
end
