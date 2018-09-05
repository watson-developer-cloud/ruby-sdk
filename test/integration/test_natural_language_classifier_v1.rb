# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["NATURAL_LANGUAGE_CLASSIFIER_USERNAME"].nil? && !ENV["NATURAL_LANGUAGE_CLASSIFIER_PASSWORD"].nil?
  # Integration tests for the Natural Language Classifier V1 Service
  class NaturalLanguageClassifierV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      @service = IBMWatson::NaturalLanguageClassifierV1.new(
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
      list_classifiers = @service.list_classifiers.result
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
      ).result
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
      ).result
      refute(classes.nil?)

      collection = [{ "text" => "How hot will it be today?" }, { "text" => "Is it hot outside?" }]
      classes = @service.classify_collection(
        classifier_id: classifier_id,
        collection: collection
      ).result
      refute(classes.nil?)

      @service.delete_classifier(
        classifier_id: classifier_id
      )
    end
  end
else
  class NaturalLanguageClassifierV1Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip natural language classifier integration tests because credentials have not been provided"
    end
  end
end
