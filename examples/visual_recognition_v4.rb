# frozen_string_literal: true

require "json"
require "ibm_watson/authenticators"
require "ibm_watson/visual_recognition_v4"

# If using IAM
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "{iam_api_key}"
)

# If you have username & password in your credentials use:
# authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
#   username: "{username}",
#   password: "{password}"
# )

# If using IAM
visual_recognition = IBMWatson::VisualRecognitionV4.new(
  version: "2018-03-19",
  authenticator: authenticator
)
visual_recognition.service_url = "{service_url}"

## Analyze multiple images
image_file_1 = File.open(Dir.getwd + "/resources/dog.jpg")
image_file_2 = File.open(Dir.getwd + "/resources/face.jpg")
result = visual_recognition.analyze(
  images_file: [
    {
      "data": image_file_1,
      "filename": "dog.jpg",
      "content_type": "image/jpeg"
    },
    {
      "data": image_file_2,
      "filename": "face.jpg",
      "content_type": "image/jpeg"
    }
  ],
  collection_ids: @collection_id,
  features: "objects"
).result
puts JSON.pretty_generate(result)

## Analyze images in zip file
File.open(Dir.getwd + "/resources/cars.zip") do |image_file|
  car_results = visual_recognition.analyze(
    images_file: [
      {
        "data": image_file,
        "filename": "dog.jpg",
        "content_type": "image/jpeg"
      }
    ],
    collection_ids: "{collection_id}",
    features: "objects"
  ).result
  puts JSON.pretty_generate(car_results)
end

## Examples to create, list, get and delete Collections
# puts JSON.pretty_generate(visual_recognition.create_collection.result)
puts JSON.pretty_generate(visual_recognition.list_collections.result)
puts JSON.pretty_generate(visual_recognition.get_collection(collection_id: "{collection_id}").result)
puts JSON.pretty_generate(visual_recognition.delete_collection(collection_id: "{collection_id}"))
