require("ibm_watson/personality_insights_v3")

# The example returns a JSON response whose content is the same as that in
#   ../resources/personality-v3-expect2.txt

# If using IAM
personality_insights = IBMWatson::PersonalityInsightsV3.new(
  iam_api_key: "IAM API KEY",
  version: "2017-10-13"
)

# If you have username & password in your credentials use:
# personality_insights = IBMWatson::PersonalityInsightsV3.new(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD",
#   version: "2017-10-13"
# )

profile = nil
File.open(Dir.getwd + "/resources/personality-v3.json") do |profile_json|
  profile = personality_insights.profile(
    content: profile_json,
    content_type: "application/json",
    raw_scores: true,
    consumption_preferences: true
  ).body
end
p profile
