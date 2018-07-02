require("watson_apis/natural_language_understanding_v1")

natural_language_understanding = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
  version: "2018-03-16",
  # username: "YOUR SERVICE USERNAME",
  # password: "YOUR SERVICE PASSWORD"
  username: ENV["NATURAL_LANGUAGE_UNDERSTANDING_USERNAME"],
  password: ENV["NATURAL_LANGUAGE_UNDERSTANDING_PASSWORD"]
)

response = natural_language_understanding.analyze(
  text: "Bruce Banner is the Hulk and Bruce Wayne is BATMAN! " \
        "Superman fears not Banner, but Wayne",
  features: {
    "entities" => {},
    "keywords" => {}
  }
).body
p response
