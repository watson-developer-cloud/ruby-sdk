# frozen_string_literal: true

require "ibm_watson/personality_insights_v3"
require "json"

# The example returns a JSON response whose content is the same as that in
#   ../resources/personality-v3-expect2.txt

# If using IAM
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "{iam_api_key}"
)

# If you have username & password in your credentials use:
# authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
#   username: "{username}",
#   password: "{password}"
# )

personality_insights = IBMWatson::PersonalityInsightsV3.new(
  authenticator: authenticator,
  version: "2017-10-13"
)
personality_insights.service_url = "{service_url}"

# If you have username & password in your credentials use:
# personality_insights = IBMWatson::PersonalityInsightsV3.new(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD",
#   version: "2017-10-13"
# )

profile = nil
File.open(Dir.getwd + "/resources/personality-v3.json") do |profile_json|
  profile = personality_insights.profile(
    accept: "application/json",
    content: profile_json,
    content_type: "application/json",
    raw_scores: true,
    consumption_preferences: true
  ).result
end
puts JSON.pretty_generate(profile)
