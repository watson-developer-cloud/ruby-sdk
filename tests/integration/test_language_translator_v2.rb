require_relative("./../../core/watson-ruby/language_translator_v2.rb")
require_relative("./../test_response_object.rb")
require("minitest/autorun")
require("faraday")

class LanguageTranslatorV2Test < Minitest::Test
  def test_translate_source_target
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    refute(service.translate(text: "Hola, cómo estás? €", source: "es", target: "en").nil?)
  end

  def test_translate_model_id
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    refute(service.translate(text: "Messi is the best ever", model_id: "en-es-conversational").nil?)
  end

  def test_list_models
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    refute(service.list_models.nil?)
  end

  def test_get_model
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    refute(service.get_model(model_id: "en-es-conversational").nil?)
  end

  def test_identify
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    refute(service.identify(text: "祝你有美好的一天").nil?)
  end

  def test_list_identifiable_languages
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    refute(service.list_identifiable_languages.nil?)
  end
end
