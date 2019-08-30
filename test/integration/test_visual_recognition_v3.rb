# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["VISUAL_RECOGNITION_APIKEY"].nil? && !ENV["VISUAL_RECOGNITION_URL"].nil?
  # Integration tests for the Visual Recognition V3 Service
  class VisualRecognitionV3Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service, :classifier_id
    def before_all
      authenticator = IBMCloudSdkCore::IamAuthenticator.new(
        apikey: ENV["VISUAL_RECOGNITION_APIKEY"]
      )
      @service = IBMWatson::VisualRecognitionV3.new(
        version: "2018-03-19",
        url: ENV["VISUAL_RECOGNITION_URL"],
        authenticator: authenticator
      )
      @classifier_id = "doxnotxdeletexsdksxintegration_718351350"
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_classify
      image_file = File.open(Dir.getwd + "/resources/dog.jpg")
      dog_results = @service.classify(
        images_file: image_file,
        threshold: "0.1",
        classifier_ids: %w[default food]
      ).result
      refute(dog_results.nil?)
    end

    def test_detect_faces
      output = @service.detect_faces(
        url: "https://www.ibm.com/ibm/ginni/images/ginni_bio_780x981_v4_03162016.jpg"
      ).result
      refute(output.nil?)
    end

    def test_custom_classifier
      skip "Time Consuming"
      cars = File.open(Dir.getwd + "/resources/cars.zip")
      trucks = File.open(Dir.getwd + "/resources/trucks.zip")
      classifier = @service.create_classifier(
        name: "CarsVsTrucks",
        positive_examples: { cars: cars },
        negative_examples: trucks
      ).result
      refute(classifier.nil?)

      classifier_id = classifier["classifier_id"]
      output = @service.get_classifier(
        classifier_id: classifier_id
      ).result
      refute(output.nil?)

      @service.delete_classifier(
        classifier_id: classifier_id
      )
    end
  end
else
  class VisualRecognitionV3Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip visual recognition integration tests because credentials have not been provided"
    end
  end
end
