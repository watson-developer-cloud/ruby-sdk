require("watson_apis/visual_recognition_v3")

test_url = "https://www.ibm.com/ibm/ginni/images/ginni_bio_780x981_v4_03162016.jpg".freeze

visual_recognition = WatsonAPIs::VisualRecognitionV3.new(
  version: "2018-03-19",
  iam_api_key: "IAM API KEY"
)

# cars = File.open(Dir.getwd + "/resources/cars.zip")
# trucks = File.open(Dir.getwd + "/resources/trucks.zip")
# p visual_recognition.create_classifier(
#   name: "Cars vs Trucks",
#   classname_positive_examples: cars,
#   negative_examples: trucks
# ).body

File.open(Dir.getwd + "/resources/cars.zip") do |images_file|
  car_results = visual_recognition.classify(
    images_file: images_file,
    threshold: 0.1,
    classifier_ids: ["defaults"]
  ).body
  p car_results
end

# p visual_recognition.get_classifier(classifier_id: "YOUR CLASSIFIER ID").body

# File.open(Dir.getwd + "/resources/car.jpg") do |image_file|
#   p visual_recognition.update_classifier(
#     classifier_id: "CarsvsTrucks_1479118188",
#     classname_positive_examples: image_file
#   ).body
# end

url_result = visual_recognition.classify(url: test_url).body
p url_result

faces_result = visual_recognition.detect_faces(url: test_url).body
p faces_result

# p visual_recognition.delete_classifier(classifier_id: "YOUR CLASSIFIER ID")

p visual_recognition.list_classifiers.body

File.open(Dir.getwd + "/resources/face.jpg") do |image_file|
  face_result = visual_recognition.detect_faces(images_file: image_file).body
  p face_result
end
