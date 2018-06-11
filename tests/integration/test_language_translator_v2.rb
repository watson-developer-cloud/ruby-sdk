# frozen_string_literal: true

require_relative("./../../core/watson-ruby/language_translator_v2.rb")
require("minitest/autorun")

class LanguageTranslatorV2Test < Minitest::Test
  Minitest::Test.parallelize_me!
  def test_translate_source_target
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    service_response = service.translate(
      text: "Hola, cómo estás? €",
      source: "es",
      target: "en"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_translate_model_id
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    service_response = service.translate(
      text: "Messi is the best ever",
      model_id: "en-es-conversational"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_models
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    service_response = service.list_models
    assert((200..299).cover?(service_response.status))
  end

  def test_get_model
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    service_response = service.get_model(
      model_id: "en-es-conversational"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_identify
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    service_response = service.identify(
      text: "祝你有美好的一天"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_identifiable_languages
    service = LanguageTranslatorV2.new(
      username: ENV["LANGUAGE_TRANSLATOR_USERNAME"],
      password: ENV["LANGUAGE_TRANSLATOR_PASSWORD"]
    )
    service_response = service.list_identifiable_languages
    assert((200..299).cover?(service_response.status))
  end
end
