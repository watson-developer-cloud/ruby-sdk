# frozen_string_literal: true

require("ibm_watson/natural_language_classifier_v1")
require("json")

# If using IAM
natural_language_classifier = IBMWatson::NaturalLanguageClassifierV1.new(
  iam_apikey: "IAM API KEY"
)

# If you have username & password in your credentials use:
# natural_language_classifier = IBMWatson::NaturalLanguageClassifierV1.new(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD"
# )

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
