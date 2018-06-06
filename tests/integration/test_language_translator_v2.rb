require_relative("./../../core/watson-ruby/language_translator_v2.rb")
require("minitest/autorun")

class LanguageTranslatorV2Test < Minitest::Test
  def test_translate_source_target
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    assert(service.translate(text: "Hola, cómo estás? €", source: "es", target: "en").status == 200)
  end

  def test_translate_model_id
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    assert(service.translate(text: "Messi is the best ever", model_id: "en-es-conversational").status == 200)
  end

  def test_list_models
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    assert(service.list_models.status == 200)
  end

  def test_get_model
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    assert(service.get_model(model_id: "en-es-conversational").status == 200)
  end

  def test_identify
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    assert(service.identify(text: "祝你有美好的一天").status == 200)
  end

  def test_list_identifiable_languages
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    assert(service.list_identifiable_languages.status == 200)
  end
end
