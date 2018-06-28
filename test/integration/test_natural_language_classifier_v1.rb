# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("minitest/hooks/test")

# Integration tests for the Natural Language Classifier V1 Service
class NaturalLanguageClassifierV1Test < Minitest::Test
  include Minitest::Hooks
  Minitest::Test.parallelize_me!
  attr_accessor :service
  def before_all
    @service = WatsonAPIs::NaturalLanguageClassifierV1.new(
      username: ENV["NATURAL_LANGUAGE_CLASSIFIER_USERNAME"],
      password: ENV["NATURAL_LANGUAGE_CLASSIFIER_PASSWORD"]
    )
    @service.add_default_headers(
      headers: {
        "X-Watson-Learning-Opt-Out" => "1",
        "X-Watson-Test" => "1"
      }
    )
  end

  def test_list_classifier
    list_classifiers = @service.list_classifiers.body
    refute(list_classifiers.nil?)
  end

  def test_classify_text
    skip "The classifier takes more than a minute"
    training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
    metadata = { "name" => "my-classifier", "language" => "en" }
    status = nil
    classifier = @service.create_classifier(
      metadata: metadata,
      training_data: training_data
    ).body
    classifier_id = classifier["classifier_id"]
    iterations = 0
    while iterations < 15
      status = @service.get_classifier(classifier_id: classifier_id)
      iterations += 1
      sleep(5) unless status["status"] == "Available"
    end
    unless status["status"] == "Available"
      @service.delete_classifier(
        classifier_id: classifier_id
      )
      assert(false, msg: "Classifier is not available")
    end

    classes = @service.classify(
      classifier_id: classifier_id,
      text: "How hot will it be tomorrow?"
    ).body
    refute(classes.nil?)

    collection = [{ "text" => "How hot will it be today?" }, { "text" => "Is it hot outside?" }]
    classes = @service.classify_collection(
      classifier_id: classifier_id,
      collection: collection
    ).body
    refute(classes.nil?)

    @service.delete_classifier(
      classifier_id: classifier_id
    )
  end
end
