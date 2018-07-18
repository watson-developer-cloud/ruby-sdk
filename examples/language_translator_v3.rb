# frozen_string_literal: true

require("ibm_watson/language_translator_v3")
require("json")

# If using IAM
language_translator = IBMWatson::LanguageTranslatorV3.new(
  version: "2018-05-31",
  ### url is optional, and defaults to the URL below. Use the correct URL for your region.
  # url: "https://gateway.watsonplatform.net/language-translator/api",
  iam_api_key: "your_api_key"
)

# If you have username & password in your credentials use:
# language_translator = IBMWatson::LanguageTranslatorV3.new(
#   version: "2018-05-31",
#   username: "username",
#   password: "password"
# )

## Translate
translation = language_translator.translate(
  text: "Hello",
  model_id: "en-es"
).result
puts JSON.pretty_generate(translation)

## List identifiable languages
# languages = language_translator.list_identifiable_languages.result
# puts JSON.pretty_generate(languages)

## Identify
# language = language_translator.identify(
#   text: "Language translator translates text from one language to another"
# ).result
# puts JSON.pretty_generate(language)

## List models
# models = language_translator.list_models(
#   source: "en"
# ).result
# puts JSON.pretty_generate(models)

## Create model
# glossary = File.open(Dir.getwd + "/resources/glossary.tmx")
# response = language_translator.create_model(
#   base_model_id: "en-es",
#   name: "custom-english-to-spanish",
#   forced_glossary: glossary
# ).result
# puts JSON.pretty_generate(response)

## Delete model
# puts JSON.pretty_generate(language_translator.delete_model(model_id: "9f8d9c6f-2123-462f-9793-f17fdcb77cd6").result)

## Get model details
# model = language_translator.get_model(model_id: "fdadfc3b-0b96-4276-a6e5-f5c4a29711fc").result
# puts JSON.pretty_generate(model)
