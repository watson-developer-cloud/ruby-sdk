# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("minitest/hooks/test")

# Integration tests for the Language Translator V3 Service
class LanguageTranslatorV3Test < Minitest::Test
  include Minitest::Hooks
  attr_accessor :service
  def before_all
    @service = IBMWatson::LanguageTranslatorV3.new(
      username: ENV["LANGUAGE_TRANSLATOR_V3_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_V3_PASSWORD"],
      version: "2018-05-01"
    )
    @service.add_default_headers(
      headers: {
        "X-Watson-Learning-Opt-Out" => "1",
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
