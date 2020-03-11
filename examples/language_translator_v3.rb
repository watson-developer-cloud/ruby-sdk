# frozen_string_literal: true

require "json"
require "ibm_watson/authenticators"
require "ibm_watson/language_translator_v3"

# If using IAM
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "{iam_api_key}"
)

# If you have username & password in your credentials use:
# authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
#   username: "{username}",
#   password: "{password}"
# )

language_translator = IBMWatson::LanguageTranslatorV3.new(
  version: "2018-05-31",
  authenticator: authenticator
)
language_translator.service_url = "{service_url}"

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

## Document translation
# list documents
document_list = language_translator.list_documents
puts JSON.pretty_generate(document_list.result)

# translate document
file = File.open(Dir.getwd + "translation_doc.txt")
document_status = language_translator.translate_document(
  file: file
)
puts JSON.pretty_generate(document_status.result)

# get document status
document_status = language_translator.get_document_status(
  document_id: "1bdb9528-bf73-45eb-87fa-c4f519af23a0"
)
puts JSON.pretty_generate(document_status)

# delete document
language_translator.delete_document(
  document_id: "1bdb9528-bf73-45eb-87fa-c4f519af23a0"
)

# get translated document
translated_document = language_translator.get_translated_document(
  document_id: "1bdb9528-bf73-45eb-87fa-c4f519af23a0"
)
puts JSON.pretty_generate(translated_document.result)
