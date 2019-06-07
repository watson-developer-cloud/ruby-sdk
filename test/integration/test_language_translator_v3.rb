# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["LANGUAGE_TRANSLATOR_APIKEY"].nil? && !ENV["LANGUAGE_TRANSLATOR_URL"].nil?
  # Integration tests for the Language Translator V3 Service
  class LanguageTranslatorV3Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      @service = IBMWatson::LanguageTranslatorV3.new(
        iam_apikey: ENV["LANGUAGE_TRANSLATOR_APIKEY"],
        url: ENV["LANGUAGE_TRANSLATOR_URL"],
        version: "2018-05-01"
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_get_model
      service_response = service.get_model(
        model_id: "en-it"
      ).result
      refute(service_response.nil?)
    end

    def test_list_models
      service_response = service.list_models.result
      refute(service_response.nil?)
    end

    def test_translate_source_target
      service_response = service.translate(
        text: "Hola, cómo estás? €",
        source: "es",
        target: "en"
      ).result
      refute(service_response.nil?)
    end

    def test_translate_model_id
      service_response = service.translate(
        text: "Messi is the best ever",
        model_id: "en-es"
      ).result
      refute(service_response.nil?)
    end

    def test_identify
      service_response = service.identify(
        text: "祝你有美好的一天"
      ).result
      refute(service_response.nil?)
    end

    def test_translate_document
      @service = IBMWatson::LanguageTranslatorV3.new(
        iam_apikey: ENV["LANGUAGE_TRANSLATOR_APIKEY"],
        url: ENV["LANGUAGE_TRANSLATOR_URL"],
        version: "2018-05-01"
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Test" => "1"
        }
      )

      File.open(Dir.getwd + "/resources/translation_doc.txt") do |file_info|
        service_response = service.translate_document(
          file: file_info,
          filename: "translation_doc.txt",
          model_id: "en-fr"
        ).result
        refute(service_response.nil?)
      end
    end

    def test_list_documents
      @service = IBMWatson::LanguageTranslatorV3.new(
        iam_apikey: ENV["LANGUAGE_TRANSLATOR_APIKEY"],
        url: ENV["LANGUAGE_TRANSLATOR_URL"],
        version: "2018-05-01"
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.list_documents.result
      refute(service_response.nil?)
    end

    def test_list_identifiable_languages
      service_response = service.list_identifiable_languages.result
      refute(service_response.nil?)
    end

    def test_create_delete_model
      skip "Methods not available in lite plans"
      custom_model = File.open(Dir.getwd + "/resources/language_translator_model.tmx")
      service_response = service.create_model(
        base_model_id: "en-fr",
        name: "test_glossary_ruby_integration",
        forced_glossary: custom_model
      ).result
      refute(service_response.nil?)
      model_id = service_response["model_id"]
      service_response = service.delete_model(
        model_id: model_id
      ).result
      assert_equal("OK", service_response["status"])
    end
  end
else
  class LanguageTranslatorV3Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip language translator integration tests because credentials have not been provided"
    end
  end
end
