# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Visual Recognition V3 Service
class VisualRecognitionV4Test < Minitest::Test
  include Minitest::Hooks
  attr_accessor :service
  def before_all
    authenticator = IBMWatson::Authenticators::NoAuthAuthenticator.new
    @service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
  end

  def test_analyze
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/analyze?version=2018-03-19").with do |req|
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
      assert_match(/Content-Disposition: form-data/, req.body)
      assert_match(/Content-Disposition: form-data; name="images_file"; filename="dog.jpg"/, req.body)
    end
    service.analyze(
      images_file: [
        {
          "data": file,
          "filename": "dog.jpg",
          "content_type": "image/jpeg"
        }
      ],
      collection_ids: ["collid"],
      features: ["animal"]
    )
  end

  def test_analyze_url
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/analyze?version=2018-03-19").with do |req|
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
      assert_match(/Content-Disposition: form-data; name="image_url"/, req.body)
    end
    service.analyze(
      image_url: [
        "www.somethingfunny.com"
      ],
      collection_ids: ["collid"],
      features: ["animal"]
    )
  end

  def test_create_collection
    response = {
      "collection_id" => "collid",
      "name" => "Dog Breeds",
      "owner" => "58b61352-678c-44d1-9f40-40edf4ea8d19",
      "status" => "passed",
      "created" => "2017-08-25T06:39:01.968Z",
      "classes" => [
        {
          "class" => "goldenretriever"
        }
      ]
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_collection(
      name: "my-collection",
      description: "A description of my collection"
    )
    assert_equal(response, service_response.result)
  end

  def test_list_collections
    response = {
      "collections" => []
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_collections
    assert_equal(response, service_response.result)
  end

  def test_get_collection
    response = {
      "collection_id" => "collid",
      "name" => "Dog Breeds",
      "owner" => "58b61352-678c-44d1-9f40-40edf4ea8d19",
      "status" => "failed",
      "created" => "2017-08-25T06:39:01.968Z",
      "classes" => [
        {
          "class" => "goldenretriever"
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_collection(
      collection_id: "collid"
    )
    assert_equal(response, service_response.result)
  end

  def test_update_collection
    response = {
      "collection_id" => "collid",
      "name" => "Dog Breeds",
      "owner" => "58b61352-678c-44d1-9f40-40edf4ea8d19",
      "status" => "failed",
      "created" => "2017-08-25T06:39:01.968Z",
      "classes" => [
        {
          "class" => "goldenretriever"
        }
      ]
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_collection(
      collection_id: "collid"
    )
    assert_equal(response, service_response.result)
  end

  def test_delete_collection
    response = {}
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_collection(
      collection_id: "collid"
    )
    assert_nil(service_response)
  end

  def test_add_images
    response = {
      "collection_id" => "collid"
    }
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_images(
      collection_id: "collid",
      images_file: [
        {
          "data": file,
          "filename": "dog.jpg",
          "content_type": "image/jpeg"
        }
      ]
    )
    assert_equal(response, service_response.result)
  end

  def test_list_images
    response = {
      "collections" => []
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_images(
      collection_id: "collid"
    )
    assert_equal(response, service_response.result)
  end

  def test_get_image_details
    response = {
      "collection_id" => "collid"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_image_details(
      collection_id: "collid",
      image_id: "imageid"
    )
    assert_equal(response, service_response.result)
  end

  def test_delete_image
    response = {}
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_image(
      collection_id: "collid",
      image_id: "imageid"
    )
    assert_nil(service_response)
  end

  def test_get_jpeg_image
    response = {
      "collection_id" => "collid"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid/jpeg?version=2018-03-19")
      .with(
        headers: {
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_jpeg_image(
      collection_id: "collid",
      image_id: "imageid"
    )
    assert_equal(response, service_response.result)
  end

  def test_train
    response = {
      "collection_id" => "collid"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/train?version=2018-03-19")
      .with(
        headers: {
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.train(
      collection_id: "collid"
    )
    assert_equal(response, service_response.result)
  end

  def test_add_image_training_data
    response = {
      "collection_id" => "collid"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid/training_data?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_image_training_data(
      collection_id: "collid",
      image_id: "imageid",
      objects: [
        {
          object: "2018-Fit",
          location: {
            top: 5,
            left: 13,
            width: 760,
            height: 419
          }
        }
      ]
    )
    assert_equal(response, service_response.result)
  end

  def test_delete_user_data
    response = {}
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v4/user_data?version=2018-03-19&customer_id=customer")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_user_data(
      customer_id: "customer"
    )
    assert_nil(service_response)
  end

  def test_get_training_usage
    response = {
      "usage" => "usage"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/training_usage?end_time=end&start_time=start&version=2018-03-19")
      .with(
        headers: {
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_training_usage(
      start_time: "start",
      end_time: "end"
    )
    assert_equal(response, service_response.result)
  end

  def test_list_object_metadata
    response = {
      "objects" => []
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/objects?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_object_metadata(
      collection_id: "collid"
    )
    assert_equal(response, service_response.result)
  end

  def test_update_object_metadata
    response = {
      "objects" => []
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/objects/old_object?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_object_metadata(
      collection_id: "collid",
      object: "old_object",
      new_object: "new_object"
    )
    assert_equal(response, service_response.result)
  end

  def test_get_object_metadata
    response = {
      "objects" => []
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/objects/object?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_object_metadata(
      collection_id: "collid",
      object: "object"
    )
    assert_equal(response, service_response.result)
  end

  def test_delete_object
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/objects/object?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: {}.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_object(
      collection_id: "collid",
      object: "object"
    )
    assert_nil(service_response)
  end

  def test_get_model_file
    response = {
      "binary" => []
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/model?feature=objects&model_format=rscnn_ready&version=2018-03-19")
      .with(
        headers: {
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_model_file(
      collection_id: "collid",
      feature: "objects",
      model_format: "rscnn_ready"
    )
    assert_equal(response, service_response.result)
  end
end
