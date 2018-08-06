# frozen_string_literal: true

require("minitest/reporters")
require("minitest/autorun")
require("minitest/retry")
require("http")
require("json")

Minitest::Retry.use!
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true), Minitest::Reporters::SpecReporter.new]

# Test to run from Travis to ensure that AppVeyor tests pass before attempting to deploy to RubyGems
class AppVeyorStatusTest < Minitest::Test
  def test_appveyor_status
    skip "Branch is NOT master and/or Ruby != 2.5.1, so AppVeyor check before deployment will not be run." if ENV["TRAVIS_BRANCH"] != "master" || ENV["TRAVIS_RUBY_VERSION"] != "2.5.1"
    client = HTTP::Client.new
    status = JSON.parse(client.get("https://ci.appveyor.com/api/projects/maxnussbaum/ruby-sdk").body.to_s)["build"]["status"]
    while status != "success" && status != "failed" && status != "cancelled"
      sleep(3)
      status = JSON.parse(client.get("https://ci.appveyor.com/api/projects/maxnussbaum/ruby-sdk").body.to_s)["build"]["status"]
    end
    if status == "success"
      assert(true)
    else
      assert(false, "AppVeyor tests have NOT passed! Please ensure that AppVeyor passes before deploying")
    end
  end
end
