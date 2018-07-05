require("watson_apis/natural_language_understanding_v1")

# If using IAM
natural_language_understanding = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
  iam_api_key: "IAM API KEY",
  version: "2018-03-16"
)

# If you have username & password in your credentials use:
# natural_language_understanding = WatsonAPIs::NaturalLanguageUnderstandingV1.new(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD",
#   version: "2018-03-16"
# )

response = natural_language_understanding.analyze(
  text: "Bruce Banner is the Hulk and Bruce Wayne is BATMAN! " \
        "Superman fears not Banner, but Wayne",
  features: {
    "entities" => {},
    "keywords" => {}
  }
).body
p response
