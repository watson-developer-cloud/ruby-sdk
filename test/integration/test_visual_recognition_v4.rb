# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["VISUAL_RECOGNITION_APIKEY"].nil? && !ENV["VISUAL_RECOGNITION_URL"].nil?
  # Integration tests for the Visual Recognition V3 Service
  class VisualRecognitionV4Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service, :classifier_id
    def before_all
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["VISUAL_RECOGNITION_APIKEY"]
      )
      @service = IBMWatson::VisualRecognitionV4.new(
        version: "2018-03-19",
        url: ENV["VISUAL_RECOGNITION_URL"],
        authenticator: authenticator
      )
      @collection_id = ENV["VISUAL_RECOGNITION_COLLECTION_ID"]
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_analyze
      image_file = File.open(Dir.getwd + "/resources/dog.jpg")
      image_file_1 = File.open(Dir.getwd + "/resources/face.jpg")
      result = @service.analyze(
        images_file: [
          {
            "data": image_file,
            "filename": "dog.jpg",
            "content_type": "image/jpeg"
          },
          {
            "data": image_file_1,
            "filename": "face.jpg",
            "content_type": "image/jpeg"
          }

        ],
        collection_ids: @collection_id,
        features: "objects"
      ).result
      assert_equal(result["images"].length, 2)
      refute(result.nil?)
    end

    def test_list_collections
      result = @service.list_collections.result
      refute(result.nil?)
    end

    def test_get_collection
      result = @service.get_collection(
        collection_id: @collection_id
      ).result
      refute(result.nil?)
    end

    def test_list_images
      result = @service.list_images(
        collection_id: @collection_id
      ).result
      refute(result.nil?)
    end
  end
else
  class VisualRecognitionV4Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip visual recognition integration tests because credentials have not been provided"
    end
  end
end
