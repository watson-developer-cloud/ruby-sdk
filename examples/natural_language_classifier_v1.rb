# frozen_string_literal: true

require "json"
require "ibm_watson/authenticators"
require "ibm_watson/natural_language_classifier_v1"

# If using IAM
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "{iam_api_key}"
)

# If you have username & password in your credentials use:
# authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
#   username: "{username}",
#   password: "{password}"
# )

natural_language_classifier = IBMWatson::NaturalLanguageClassifierV1.new(
  authenticator: authenticator
)
natural_language_classifier.service_url = "{service_url}"

classifiers = natural_language_classifier.list_classifiers.result
puts JSON.pretty_generate(classifiers)

# create a classifier
training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
metadata = {
  "name" => "my-classifier",
  "language" => "en"
}
classifier = natural_language_classifier.create_classifier(
  metadata: metadata,
  training_data: training_data
).result
classifier_id = classifier["classifier_id"]
puts JSON.pretty_generate(classifier)

status = natural_language_classifier.get_classifier(
  classifier_id: classifier_id
).result
puts JSON.pretty_generate(status)

if status["status"] == "Available"
  classes = natural_language_classifier.classify(
    classifier_id: classifier_id,
    text: "How hot will it be tomorrow?"
  ).result
  puts JSON.pretty_generate(classes)
end

if status["status"] == "Available"
  collection = [{ "text" => "How hot will it be today?" }, { "text" => "Is it hot outside?" }]
  classes = natural_language_classifier.classify_collection(
    classifier_id: classifier_id,
    collection: collection
  ).result
  puts JSON.pretty_generate(classes)
end

delete = natural_language_classifier.delete_classifier(classifier_id: classifier_id).result
puts JSON.pretty_generate(delete)
