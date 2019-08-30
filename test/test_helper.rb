# frozen_string_literal: true

require("simplecov")
require("codecov")
require("minitest/reporters")

if ENV["COVERAGE"]
  SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV["CI"]
  unless SimpleCov.running
    SimpleCov.start do
      add_filter "/test/"
      add_filter do |src_file|
        File.basename(src_file.filename) == "version.rb"
      end

      command_name "Minitest"
    end
  end
end

require("minitest/autorun")
require_relative("./../lib/ibm_watson.rb")
require("minitest/retry")
require("minitest/hooks/test")
require("ibm_cloud_sdk_core")

Minitest::Retry.use!

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true, slow_count: 10), Minitest::Reporters::SpecReporter.new, Minitest::Reporters::HtmlReporter.new] if ENV["CI"].nil?
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true, slow_count: 10), Minitest::Reporters::SpecReporter.new] if ENV["CI"]
